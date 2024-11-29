LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tim_TOP IS
  PORT (
    -- Глобальные сигналы
    clk       : IN  STD_LOGIC;
    reset     : IN  STD_LOGIC;

    -- AXI4-MM Write Address Channel
    AWADDR    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    AWVALID   : IN  STD_LOGIC;
    AWREADY   : OUT STD_LOGIC;

    -- AXI4-MM Write Data Channel
    WDATA     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    WVALID    : IN  STD_LOGIC;
    WREADY    : OUT STD_LOGIC;

    -- AXI4-MM Write Response Channel
    BRESP     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    BVALID    : OUT STD_LOGIC;
    BREADY    : IN  STD_LOGIC;

    -- AXI4-MM Read Address Channel
    ARADDR    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    ARVALID   : IN  STD_LOGIC;
    ARREADY   : OUT STD_LOGIC;

    -- AXI4-MM Read Data Channel
    RDATA     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    RVALID    : OUT STD_LOGIC;
    RREADY    : IN  STD_LOGIC
  );
END ENTITY tim_TOP;

ARCHITECTURE rtl OF tim_TOP IS

  -- Определение состояний для каждого FSM
  TYPE state_type IS (IDLE, WAIT_FOR_VALID, WAIT_FOR_READY);

  -- FSM Write Address
  SIGNAL aw_state : state_type := IDLE;
  SIGNAL awready_internal : STD_LOGIC := '0';

  -- FSM Write Data
  SIGNAL w_state : state_type := IDLE;
  SIGNAL wready_internal : STD_LOGIC := '0';

  -- FSM Write Response
  SIGNAL b_state : state_type := IDLE;
  SIGNAL bvalid_internal : STD_LOGIC := '0';
  SIGNAL bresp_internal : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

  -- FSM Read Address
  SIGNAL ar_state : state_type := IDLE;
  SIGNAL arready_internal : STD_LOGIC := '0';

  -- FSM Read Data
  SIGNAL r_state : state_type := IDLE;
  SIGNAL rvalid_internal : STD_LOGIC := '0';
  SIGNAL rdata_internal : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

  -- Временные сигналы
  SIGNAL internal_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL encrypted_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0'); -- Зашифрованные данные

  -- Функция переворачивания данных
  FUNCTION reverse_data(data : STD_LOGIC_VECTOR(31 DOWNTO 0)) RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO 0);
  BEGIN
    -- Переворачиваем входные данные
    FOR i IN 0 TO 31 LOOP
      result(i) := data(31 - i);
    END LOOP;
    RETURN result;
  END FUNCTION;

BEGIN
  -- Присваивание внутренних сигналов выходам
  AWREADY <= awready_internal;
  WREADY <= wready_internal;
  BRESP <= bresp_internal;
  BVALID <= bvalid_internal;
  ARREADY <= arready_internal;
  RVALID <= rvalid_internal;
  RDATA <= rdata_internal;

  -- FSM для адреса записи
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      aw_state <= IDLE;
      awready_internal <= '0';
    ELSIF rising_edge(clk) THEN
      CASE aw_state IS
        WHEN IDLE =>
          IF AWVALID = '1' THEN
            awready_internal <= '1';
            aw_state <= WAIT_FOR_VALID;
            report "FSM Write Address: Transition to WAIT_FOR_VALID";
          END IF;
        WHEN WAIT_FOR_VALID =>
          IF AWVALID = '0' THEN
            awready_internal <= '0';
            aw_state <= IDLE;
            report "FSM Write Address: Return to IDLE";
          END IF;
        WHEN OTHERS =>
          aw_state <= IDLE;
      END CASE;
    END IF;
  END PROCESS;

  -- FSM для данных записи
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      w_state <= IDLE;
      wready_internal <= '0';
    ELSIF rising_edge(clk) THEN
      CASE w_state IS
        WHEN IDLE =>
          IF WVALID = '1' THEN
            wready_internal <= '1';
            internal_data <= WDATA; -- Сохраняем записанные данные
            encrypted_data <= reverse_data(WDATA); -- Переворачиваем данные
            report "FSM Write Data: Data received and reversed";
            w_state <= WAIT_FOR_VALID;
          END IF;
        WHEN WAIT_FOR_VALID =>
          IF WVALID = '0' THEN
            wready_internal <= '0';
            w_state <= IDLE;
            report "FSM Write Data: Return to IDLE";
          END IF;
        WHEN OTHERS =>
          w_state <= IDLE;
      END CASE;
    END IF;
  END PROCESS;

  -- FSM для подтверждения записи
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      b_state <= IDLE;
      bvalid_internal <= '0';
      bresp_internal <= "00";
    ELSIF rising_edge(clk) THEN
      CASE b_state IS
        WHEN IDLE =>
          IF wready_internal = '1' AND WVALID = '0' THEN
            bvalid_internal <= '1';
            b_state <= WAIT_FOR_READY;
            report "FSM Write Response: Transition to WAIT_FOR_READY";
          END IF;
        WHEN WAIT_FOR_READY =>
          IF BREADY = '1' THEN
            bvalid_internal <= '0';
            b_state <= IDLE;
            report "FSM Write Response: Return to IDLE";
          END IF;
        WHEN OTHERS =>
          b_state <= IDLE;
      END CASE;
    END IF;
  END PROCESS;

  -- FSM для адреса чтения
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      ar_state <= IDLE;
      arready_internal <= '0';
    ELSIF rising_edge(clk) THEN
      CASE ar_state IS
        WHEN IDLE =>
          IF ARVALID = '1' THEN
            arready_internal <= '1';
            ar_state <= WAIT_FOR_VALID;
            report "FSM Read Address: Transition to WAIT_FOR_VALID";
          END IF;
        WHEN WAIT_FOR_VALID =>
          IF ARVALID = '0' THEN
            arready_internal <= '0';
            ar_state <= IDLE;
            report "FSM Read Address: Return to IDLE";
          END IF;
        WHEN OTHERS =>
          ar_state <= IDLE;
      END CASE;
    END IF;
  END PROCESS;

  -- FSM для данных чтения
  PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      r_state <= IDLE;
      rvalid_internal <= '0';
      rdata_internal <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      CASE r_state IS
        WHEN IDLE =>
          IF arready_internal = '1' THEN
            rdata_internal <= encrypted_data; -- Передаём перевёрнутые данные
            rvalid_internal <= '1';
            report "FSM Read Data: Sending reversed data";
            r_state <= WAIT_FOR_READY;
          END IF;
        WHEN WAIT_FOR_READY =>
          IF RREADY = '1' THEN
            rvalid_internal <= '0';
            r_state <= IDLE;
            report "FSM Read Data: Return to IDLE";
          END IF;
        WHEN OTHERS =>
          r_state <= IDLE;
      END CASE;
    END IF;
  END PROCESS;

END ARCHITECTURE rtl;
