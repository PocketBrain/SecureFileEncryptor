LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY axi4_fsm_tb IS
END ENTITY axi4_fsm_tb;

ARCHITECTURE sim OF axi4_fsm_tb IS
  COMPONENT tim_TOP
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
  END COMPONENT;

  -- Сигналы для тестирования
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL reset     : STD_LOGIC := '0';
  SIGNAL AWADDR    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL AWVALID   : STD_LOGIC := '0';
  SIGNAL AWREADY   : STD_LOGIC;
  SIGNAL WDATA     : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL WVALID    : STD_LOGIC := '0';
  SIGNAL WREADY    : STD_LOGIC;
  SIGNAL BRESP     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL BVALID    : STD_LOGIC;
  SIGNAL BREADY    : STD_LOGIC := '0';
  SIGNAL ARADDR    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  SIGNAL ARVALID   : STD_LOGIC := '0';
  SIGNAL ARREADY   : STD_LOGIC;
  SIGNAL RDATA     : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL RVALID    : STD_LOGIC;
  SIGNAL RREADY    : STD_LOGIC := '0';

  -- Ожидаемое значение
  CONSTANT EXPECTED_ENCRYPTED_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"F7DB7B5B"; -- Перевернутый DEADBEEF

  -- Функция для преобразования std_logic_vector в строку
  FUNCTION std_logic_vector_to_string(signal_data : STD_LOGIC_VECTOR) RETURN STRING IS
    VARIABLE result : STRING(1 TO signal_data'length);
  BEGIN
    FOR i IN signal_data'range LOOP
      IF signal_data(i) = '1' THEN
        result(signal_data'length - i) := '1';
      ELSE
        result(signal_data'length - i) := '0';
      END IF;
    END LOOP;
    RETURN result;
  END FUNCTION;

BEGIN
  -- Подключение DUT (Device Under Test)
  DUT : tim_TOP
    PORT MAP (
      clk       => clk,
      reset     => reset,
      AWADDR    => AWADDR,
      AWVALID   => AWVALID,
      AWREADY   => AWREADY,
      WDATA     => WDATA,
      WVALID    => WVALID,
      WREADY    => WREADY,
      BRESP     => BRESP,
      BVALID    => BVALID,
      BREADY    => BREADY,
      ARADDR    => ARADDR,
      ARVALID   => ARVALID,
      ARREADY   => ARREADY,
      RDATA     => RDATA,
      RVALID    => RVALID,
      RREADY    => RREADY
    );

  -- Генерация тактового сигнала
  clk_process : PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR 5 ns;
    clk <= '1';
    WAIT FOR 5 ns;
  END PROCESS;

  -- Генерация стимулов
  stim_process : PROCESS
  BEGIN
    -- Сброс
    report "Stimulus: Applying reset...";
    reset <= '1';
    WAIT FOR 20 ns;
    reset <= '0';
    report "Stimulus: Reset deasserted.";

    -- Тест записи
    report "Stimulus: Starting write transaction...";
    AWADDR <= X"00000010";
    AWVALID <= '1';
    WDATA <= X"DEADBEEF";
    WVALID <= '1';

    -- Ожидание подтверждения адреса
    WAIT UNTIL AWREADY = '1' FOR 50 ns;
    IF AWREADY /= '1' THEN
      report "Error: AWREADY did not assert within 50 ns" SEVERITY ERROR;
    ELSE
      report "Stimulus: AWREADY asserted. Address accepted.";
    END IF;
    AWVALID <= '0';

    -- Ожидание подтверждения данных
    WAIT UNTIL WREADY = '1' FOR 50 ns;
    IF WREADY /= '1' THEN
      report "Error: WREADY did not assert within 50 ns" SEVERITY ERROR;
    ELSE
      report "Stimulus: WREADY asserted. Data accepted.";
    END IF;
    WVALID <= '0';

    -- Ожидание завершения записи
    WAIT UNTIL BVALID = '1' FOR 50 ns;
    IF BVALID /= '1' THEN
      report "Error: BVALID did not assert within 50 ns" SEVERITY ERROR;
    ELSE
      report "Stimulus: BVALID asserted. Write response received.";
    END IF;
    BREADY <= '1';
    WAIT FOR 10 ns;
    BREADY <= '0';

    -- Тест чтения
    report "Stimulus: Starting read transaction...";
    ARADDR <= X"00000010";
    ARVALID <= '1';
    WAIT UNTIL ARREADY = '1' FOR 50 ns;
    IF ARREADY /= '1' THEN
      report "Error: ARREADY did not assert within 50 ns" SEVERITY ERROR;
    ELSE
      report "Stimulus: ARREADY asserted. Address accepted.";
    END IF;
    ARVALID <= '0';

    -- Ожидание данных чтения
    WAIT UNTIL RVALID = '1' FOR 50 ns;
    IF RVALID /= '1' THEN
      report "Error: RVALID did not assert within 50 ns" SEVERITY ERROR;
    ELSE
      report "Stimulus: RVALID asserted. Data available.";
    END IF;
    RREADY <= '1';
    WAIT FOR 10 ns;

    -- Проверка данных
    report "Stimulus: Checking encrypted data...";
    IF RDATA /= EXPECTED_ENCRYPTED_DATA THEN
      report "Error: Encrypted data mismatch! Expected: " &
             std_logic_vector_to_string(EXPECTED_ENCRYPTED_DATA) &
             ", Received: " &
             std_logic_vector_to_string(RDATA) SEVERITY ERROR;
    ELSE
      report "Success: Encrypted data received correctly: " &
             std_logic_vector_to_string(RDATA);
    END IF;

    RREADY <= '0';

    -- Завершение симуляции
    WAIT FOR 50 ns;
    ASSERT FALSE REPORT "Simulation completed successfully!" SEVERITY NOTE;
    WAIT;
  END PROCESS;

END ARCHITECTURE sim;
