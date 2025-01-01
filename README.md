### ALU (Arithmetic Logic Unit)

This module implements a parameterized **Arithmetic Logic Unit (ALU)** in Verilog HDL. The ALU performs a variety of arithmetic and logical operations on two \(N\)-bit binary inputs, supporting customizable bit widths for flexible integration into larger systems.

#### Features:
- **Parameterizable Bit Width**: Default is \(N = 32\), adjustable for various applications.
- **Comprehensive Operations**:
  - Arithmetic: Addition, subtraction, multiplication, division, modulus.
  - Logical: AND, OR, XOR, NOT.
  - Bitwise shifts: Logical left (\(<<\)), logical right (\(>>\)), arithmetic right (\($signed(a) >>>\)).
  - Comparison: Equality, less-than, greater-than.
- **Status Flags**:
  - **Zero (zero)**: Asserted when the result is zero.
  - **Negative (negative)**: Indicates the sign of the result for signed operations.
  - **Overflow (overflow)**: Detects arithmetic overflow for addition and subtraction.
  - **Carry (carry)**: Captures carry-out for addition and borrow for subtraction.

#### Inputs:
- **a**: First \(N\)-bit binary operand.
- **b**: Second \(N\)-bit binary operand.
- **ctrl**: 4-bit control signal specifying the operation.

#### Outputs:
- **result**: \(N\)-bit result of the specified operation.
- **zero**: High if the result is zero.
- **negative**: High if the result is negative.
- **overflow**: High if arithmetic overflow occurs.
- **carry**: High if a carry-out (or borrow) occurs.

#### Operation Control Codes (ctrl):
| **Code (ctrl)** | **Operation**               |
|------------------|-----------------------------|
| 4'b0000          | Addition (\(a + b\))        |
| 4'b0001          | Subtraction (\(a - b\))     |
| 4'b0010          | Bitwise AND (\(a \& b\))    |
| 4'b0011          | Bitwise OR (\(a | b\))      |
| 4'b0100          | Bitwise XOR (\(a \ XOR b\))|
| 4'b0101          | Bitwise NOT (\(~a\))        |
| 4'b0110          | Logical Left Shift (\(a << b[3:0]\)) |
| 4'b0111          | Logical Right Shift (\(a >> b[3:0]\)) |
| 4'b1000          | Arithmetic Right Shift (\($signed(a) >>> b[3:0]\)) |
| 4'b1001          | Equality (\(a == b\))       |
| 4'b1010          | Less Than (\(a < b\))       |
| 4'b1011          | Greater Than (\(a > b\))    |
| 4'b1100          | Multiplication (\(a[N/2:0] * b[N/2:0]\)) |
| 4'b1101          | Division (\(a / b\))        |
| 4'b1110          | Modulus (\(a \% b\))        |

#### Error Handling:
- Division and modulus operations handle division by zero by returning \(0\).
- Displays a warning message if the parameter \(N\) is out of the range \(4 \leq N \leq 32\).

#### Usage:
This ALU can be used in:
- Processor cores for arithmetic and logic operations.
- Digital signal processing units.
- Custom hardware accelerators requiring flexible arithmetic and logic functions.
