# VHDL UART Implementation for PYNQ-Z2

## Project Description

This project focuses on the implementation, hardware synthesis, and testing of a UART (Universal Asynchronous Receiver/Transmitter) module using VHDL.  
The target hardware platform is the **PYNQ-Z2** board, utilizing the Xilinx Zynq-7000 FPGA.  
It involves integrating custom UART Receiver (RX) and Transmitter (TX) components into the provided IP core (`simple_uart_1.0`) and testing the communication via a Python script running on the PYNQ-Z2's ARM processor.

This project was developed as part of the **INC (Computer Architectures)** course curriculum.

---

## Features

- **UART Receiver (RX) Implementation**:  
  VHDL implementation of UART receiving logic, including start bit detection, data bit sampling, and stop bit validation.  
  Includes a finite state machine (`UART_RX_FSM`) to manage the reception process.  
  *(Files: `uart_rx.vhd`, `uart_rx_fsm.vhd`)*

- **UART Transmitter (TX) Implementation**:  
  VHDL implementation of UART transmitting logic (either custom or sample code).  
  *(Files: `uart_tx.vhd`, `uart_tx_fsm.vhd`)*

- **Hardware Integration**:  
  Integration of RX and TX modules into the `simple_uart_1.0` IP core.

- **FPGA Synthesis**:  
  Hardware design built using **Xilinx Vivado**, connecting UART IP core to the Zynq Processing System via AXI bus.

- **Hardware Testing**:  
  Testing UART communication via a Python script (`uart_echo.py`) on PYNQ-Z2:
  - **Loopback Test** (connecting TXD to RXD on the same board)
  - **Peer-to-Peer Test** (connecting two PYNQ-Z2 boards)

---

## Hardware/Software Requirements

- **FPGA Board**: PYNQ-Z2 Kit
- **Development Tool**: Xilinx Vivado (tested with versions 2018.2 and 2020.1)
- **Accessories**:
  - Micro-SD card with PYNQ image
  - Micro-USB cable
  - RJ45 Ethernet cable
  - DuPont M-M jumper wires (for loopback and peer-to-peer tests)
- **Software**:
  - Python 3 (on PYNQ-Z2)
  - Serial terminal client (e.g., PuTTY)
  - (Optional) VirtualBox with Ubuntu VM, or local Vivado installation

---

## Implementation Details

### UART Receiver (`uart_rx.vhd`, `uart_rx_fsm.vhd`)

- Detects a start bit (`'0'`) on the `DIN` line.
- Samples data bits at appropriate intervals using a finite state machine (FSM) and counters.
- Collects 8 data bits into the `DOUT` register.
- After successful reception and stop bit validation, asserts `DOUT_VLD` for one clock cycle.

### UART Transmitter (`uart_tx.vhd`, `uart_tx_fsm.vhd`)

*(Depending on custom or sample implementation)*

- Sends a start bit, data bits (LSB first), and a stop bit.
- Manages timing and transmission using an FSM and counters.

---

## Building the Hardware (Vivado Synthesis)

1. **Install Vivado** (2018.2 or 2020.1).
2. **Prepare VHDL Files**:  
   Place your `uart_rx.vhd`, `uart_rx_fsm.vhd`, `uart_tx.vhd`, and `uart_tx_fsm.vhd` into `ip_cores/simple_uart_1.0/hdl/`.

3. **(Optional) Inspect IP Core**:
  - Open the Vivado project `simple_uart_v1_0.xpr`.
  - View the elaborated design and package the IP if modified.

4. **Build Overlay**:
  - Navigate to the `overlay/` directory.
  - Run the build scripts:
    ```bash
    vivado -mode batch -source build_blockdesign.tcl -notrace
    vivado -mode batch -source build_bitstream.tcl -notrace
    ```

5. **Generated Files**:
  - `inc_uart.bit` and `inc_uart.hwh` will be created in `overlay/`.

---

## Running on PYNQ-Z2

1. **Prepare Board**: Connect USB and Ethernet.
2. **Transfer Files**:
  - `uart_echo.py`
  - `overlay/inc_uart.py`
  - `overlay/inc_uart.bit`
  - `overlay/inc_uart.hwh`

3. **Serial Connection**:
  - Use PuTTY or another client to connect to `/dev/ttyUSB1` (Linux) or appropriate COM port (Windows).
  - Baud rate: 115200.

5. Loopback Test:
   - Connect RXD to TXD pins on PMODB.
   - Sent messages should be echoed back.

6. Peer-to-Peer Test (Optional):
   - Connect two PYNQ-Z2 boards crossing TXD and RXD. 
   - Messages should appear on both terminals.
