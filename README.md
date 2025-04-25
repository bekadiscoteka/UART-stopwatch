# ⏱️ UART Stopwatch with Auto Baud Rate Detection

An FPGA-based stopwatch that **automatically detects baud rate**, counts time with **millisecond precision**, and communicates via UART using **ASCII control characters**.

---

## 📌 Features

- **Auto Baud Rate Detection**  
  Just transmit any character after reset — the system detects the baud rate and lights up the **READY LED**.
  
- **Millisecond Precision**  
  Stopwatch counts in `D.DDD` format (e.g., `5.124` = 5 seconds, 124 milliseconds).
  
- **ASCII Control via UART**
  Control the stopwatch using simple ASCII characters:
  
  | Command | Description              |
  |---------|--------------------------|
  | `g` / `G` | Start the stopwatch       |
  | `p` / `P` | Pause the stopwatch       |
  | `c` / `C` | Clear (reset) the stopwatch |
  | `r` / `R` | Receive the current time via UART |

  Watch it in action:  
[![Demo Video](https://img.youtube.com/vi/HNC9ARV29Qs/0.jpg)]([https://youtu.be/HNC9ARV29Qs?si=Q1hFCuhOhmJZtufv](https://youtu.be/-5vMRhQ4sdg?si=xdsuIJsofNL2X6w2))

---

## 🧠 How It Works

1. **Reset the system.**
2. **Transmit any character** from your terminal to the FPGA.
   - The **READY LED** will light up, confirming baud rate detection.
3. Now you can **control the stopwatch** using ASCII characters.

---





