library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Encryption_Core_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface data_in
		C_data_in_DATA_WIDTH	: integer	:= 32;
		C_data_in_ADDR_WIDTH	: integer	:= 5;

		-- Parameters of Axi Slave Bus Interface key_in
		C_key_in_DATA_WIDTH	: integer	:= 32;
		C_key_in_ADDR_WIDTH	: integer	:= 5;

		-- Parameters of Axi Master Bus Interface data_out
		C_data_out_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		C_data_out_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_data_out_ADDR_WIDTH	: integer	:= 32;
		C_data_out_DATA_WIDTH	: integer	:= 32;
		C_data_out_TRANSACTIONS_NUM	: integer	:= 4
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface data_in
		data_in_aclk	: in std_logic;
		data_in_aresetn	: in std_logic;
		data_in_awaddr	: in std_logic_vector(C_data_in_ADDR_WIDTH-1 downto 0);
		data_in_awprot	: in std_logic_vector(2 downto 0);
		data_in_awvalid	: in std_logic;
		data_in_awready	: out std_logic;
		data_in_wdata	: in std_logic_vector(C_data_in_DATA_WIDTH-1 downto 0);
		data_in_wstrb	: in std_logic_vector((C_data_in_DATA_WIDTH/8)-1 downto 0);
		data_in_wvalid	: in std_logic;
		data_in_wready	: out std_logic;
		data_in_bresp	: out std_logic_vector(1 downto 0);
		data_in_bvalid	: out std_logic;
		data_in_bready	: in std_logic;
		data_in_araddr	: in std_logic_vector(C_data_in_ADDR_WIDTH-1 downto 0);
		data_in_arprot	: in std_logic_vector(2 downto 0);
		data_in_arvalid	: in std_logic;
		data_in_arready	: out std_logic;
		data_in_rdata	: out std_logic_vector(C_data_in_DATA_WIDTH-1 downto 0);
		data_in_rresp	: out std_logic_vector(1 downto 0);
		data_in_rvalid	: out std_logic;
		data_in_rready	: in std_logic;

		-- Ports of Axi Slave Bus Interface key_in
		key_in_aclk	: in std_logic;
		key_in_aresetn	: in std_logic;
		key_in_awaddr	: in std_logic_vector(C_key_in_ADDR_WIDTH-1 downto 0);
		key_in_awprot	: in std_logic_vector(2 downto 0);
		key_in_awvalid	: in std_logic;
		key_in_awready	: out std_logic;
		key_in_wdata	: in std_logic_vector(C_key_in_DATA_WIDTH-1 downto 0);
		key_in_wstrb	: in std_logic_vector((C_key_in_DATA_WIDTH/8)-1 downto 0);
		key_in_wvalid	: in std_logic;
		key_in_wready	: out std_logic;
		key_in_bresp	: out std_logic_vector(1 downto 0);
		key_in_bvalid	: out std_logic;
		key_in_bready	: in std_logic;
		key_in_araddr	: in std_logic_vector(C_key_in_ADDR_WIDTH-1 downto 0);
		key_in_arprot	: in std_logic_vector(2 downto 0);
		key_in_arvalid	: in std_logic;
		key_in_arready	: out std_logic;
		key_in_rdata	: out std_logic_vector(C_key_in_DATA_WIDTH-1 downto 0);
		key_in_rresp	: out std_logic_vector(1 downto 0);
		key_in_rvalid	: out std_logic;
		key_in_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface data_out
		data_out_init_axi_txn	: in std_logic;
		data_out_error	: out std_logic;
		data_out_txn_done	: out std_logic;
		data_out_aclk	: in std_logic;
		data_out_aresetn	: in std_logic;
		data_out_awaddr	: out std_logic_vector(C_data_out_ADDR_WIDTH-1 downto 0);
		data_out_awprot	: out std_logic_vector(2 downto 0);
		data_out_awvalid	: out std_logic;
		data_out_awready	: in std_logic;
		data_out_wdata	: out std_logic_vector(C_data_out_DATA_WIDTH-1 downto 0);
		data_out_wstrb	: out std_logic_vector(C_data_out_DATA_WIDTH/8-1 downto 0);
		data_out_wvalid	: out std_logic;
		data_out_wready	: in std_logic;
		data_out_bresp	: in std_logic_vector(1 downto 0);
		data_out_bvalid	: in std_logic;
		data_out_bready	: out std_logic;
		data_out_araddr	: out std_logic_vector(C_data_out_ADDR_WIDTH-1 downto 0);
		data_out_arprot	: out std_logic_vector(2 downto 0);
		data_out_arvalid	: out std_logic;
		data_out_arready	: in std_logic;
		data_out_rdata	: in std_logic_vector(C_data_out_DATA_WIDTH-1 downto 0);
		data_out_rresp	: in std_logic_vector(1 downto 0);
		data_out_rvalid	: in std_logic;
		data_out_rready	: out std_logic
	);
end Encryption_Core_v1_0;

architecture arch_imp of Encryption_Core_v1_0 is

	-- component declaration
	component Encryption_Core_v1_0_data_in is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component Encryption_Core_v1_0_data_in;

	component Encryption_Core_v1_0_key_in is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component Encryption_Core_v1_0_key_in;

	component Encryption_Core_v1_0_data_out is
		generic (
		C_M_START_DATA_VALUE	: std_logic_vector	:= x"AA000000";
		C_M_TARGET_SLAVE_BASE_ADDR	: std_logic_vector	:= x"40000000";
		C_M_AXI_ADDR_WIDTH	: integer	:= 32;
		C_M_AXI_DATA_WIDTH	: integer	:= 32;
		C_M_TRANSACTIONS_NUM	: integer	:= 4
		);
		port (
		INIT_AXI_TXN	: in std_logic;
		ERROR	: out std_logic;
		TXN_DONE	: out std_logic;
		M_AXI_ACLK	: in std_logic;
		M_AXI_ARESETN	: in std_logic;
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		M_AXI_AWVALID	: out std_logic;
		M_AXI_AWREADY	: in std_logic;
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		M_AXI_WVALID	: out std_logic;
		M_AXI_WREADY	: in std_logic;
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		M_AXI_BVALID	: in std_logic;
		M_AXI_BREADY	: out std_logic;
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		M_AXI_ARVALID	: out std_logic;
		M_AXI_ARREADY	: in std_logic;
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		M_AXI_RVALID	: in std_logic;
		M_AXI_RREADY	: out std_logic
		);
	end component Encryption_Core_v1_0_data_out;

begin

-- Instantiation of Axi Bus Interface data_in
Encryption_Core_v1_0_data_in_inst : Encryption_Core_v1_0_data_in
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_data_in_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_data_in_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> data_in_aclk,
		S_AXI_ARESETN	=> data_in_aresetn,
		S_AXI_AWADDR	=> data_in_awaddr,
		S_AXI_AWPROT	=> data_in_awprot,
		S_AXI_AWVALID	=> data_in_awvalid,
		S_AXI_AWREADY	=> data_in_awready,
		S_AXI_WDATA	=> data_in_wdata,
		S_AXI_WSTRB	=> data_in_wstrb,
		S_AXI_WVALID	=> data_in_wvalid,
		S_AXI_WREADY	=> data_in_wready,
		S_AXI_BRESP	=> data_in_bresp,
		S_AXI_BVALID	=> data_in_bvalid,
		S_AXI_BREADY	=> data_in_bready,
		S_AXI_ARADDR	=> data_in_araddr,
		S_AXI_ARPROT	=> data_in_arprot,
		S_AXI_ARVALID	=> data_in_arvalid,
		S_AXI_ARREADY	=> data_in_arready,
		S_AXI_RDATA	=> data_in_rdata,
		S_AXI_RRESP	=> data_in_rresp,
		S_AXI_RVALID	=> data_in_rvalid,
		S_AXI_RREADY	=> data_in_rready
	);

-- Instantiation of Axi Bus Interface key_in
Encryption_Core_v1_0_key_in_inst : Encryption_Core_v1_0_key_in
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_key_in_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_key_in_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> key_in_aclk,
		S_AXI_ARESETN	=> key_in_aresetn,
		S_AXI_AWADDR	=> key_in_awaddr,
		S_AXI_AWPROT	=> key_in_awprot,
		S_AXI_AWVALID	=> key_in_awvalid,
		S_AXI_AWREADY	=> key_in_awready,
		S_AXI_WDATA	=> key_in_wdata,
		S_AXI_WSTRB	=> key_in_wstrb,
		S_AXI_WVALID	=> key_in_wvalid,
		S_AXI_WREADY	=> key_in_wready,
		S_AXI_BRESP	=> key_in_bresp,
		S_AXI_BVALID	=> key_in_bvalid,
		S_AXI_BREADY	=> key_in_bready,
		S_AXI_ARADDR	=> key_in_araddr,
		S_AXI_ARPROT	=> key_in_arprot,
		S_AXI_ARVALID	=> key_in_arvalid,
		S_AXI_ARREADY	=> key_in_arready,
		S_AXI_RDATA	=> key_in_rdata,
		S_AXI_RRESP	=> key_in_rresp,
		S_AXI_RVALID	=> key_in_rvalid,
		S_AXI_RREADY	=> key_in_rready
	);

-- Instantiation of Axi Bus Interface data_out
Encryption_Core_v1_0_data_out_inst : Encryption_Core_v1_0_data_out
	generic map (
		C_M_START_DATA_VALUE	=> C_data_out_START_DATA_VALUE,
		C_M_TARGET_SLAVE_BASE_ADDR	=> C_data_out_TARGET_SLAVE_BASE_ADDR,
		C_M_AXI_ADDR_WIDTH	=> C_data_out_ADDR_WIDTH,
		C_M_AXI_DATA_WIDTH	=> C_data_out_DATA_WIDTH,
		C_M_TRANSACTIONS_NUM	=> C_data_out_TRANSACTIONS_NUM
	)
	port map (
		INIT_AXI_TXN	=> data_out_init_axi_txn,
		ERROR	=> data_out_error,
		TXN_DONE	=> data_out_txn_done,
		M_AXI_ACLK	=> data_out_aclk,
		M_AXI_ARESETN	=> data_out_aresetn,
		M_AXI_AWADDR	=> data_out_awaddr,
		M_AXI_AWPROT	=> data_out_awprot,
		M_AXI_AWVALID	=> data_out_awvalid,
		M_AXI_AWREADY	=> data_out_awready,
		M_AXI_WDATA	=> data_out_wdata,
		M_AXI_WSTRB	=> data_out_wstrb,
		M_AXI_WVALID	=> data_out_wvalid,
		M_AXI_WREADY	=> data_out_wready,
		M_AXI_BRESP	=> data_out_bresp,
		M_AXI_BVALID	=> data_out_bvalid,
		M_AXI_BREADY	=> data_out_bready,
		M_AXI_ARADDR	=> data_out_araddr,
		M_AXI_ARPROT	=> data_out_arprot,
		M_AXI_ARVALID	=> data_out_arvalid,
		M_AXI_ARREADY	=> data_out_arready,
		M_AXI_RDATA	=> data_out_rdata,
		M_AXI_RRESP	=> data_out_rresp,
		M_AXI_RVALID	=> data_out_rvalid,
		M_AXI_RREADY	=> data_out_rready
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
