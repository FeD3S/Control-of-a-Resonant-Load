# Position Control of a DC Servomotor with Resonant Load

## Authors
* **Federico Saporiti**
* **Davide Pillon**
* **Leonardo Luigi Pepe**
  
Msc in Control Systems Engineering

## Overview
This repository contains the models, scripts, and documentation for designing and validating a digital position control system. The setup replaces the original motor load with a rigid beam connected via an elastic joint. 

The project evaluates classical and modern control approaches for dealing with resonance and anti-resonance phenomena.

## Project Objectives
The core tasks of this activity include:
1. **System Identification:** Calculating physical parameters through free oscillation analysis.
2. **PID Control:** Developing a controller with anti-windup and derivative filtering.
3. **State-Space Control:** Employing eigenvalue placement with integral action and a high-pass filter for velocity estimation.
4. **LQR:** Implementing a Linear Quadratic Regulator using both Symmetric Root Locus and Bryson's rule.
5. **Frequency-Shaped LQR:** Applying frequency-dependent weights to attenuate resonant oscillations.

**Performance Constraints:** Settling time ≤ 0.85 s and overshoot ≤ 30%.

## Repository Structure
* `/models`: Simulink files for the plant and control architectures.
* `/scripts`: MATLAB scripts for parameter estimation, PID tuning, and LQR cost calculations.
* `/data`: Workspace data and logs of the system's natural responses.

## Results Summary
The performance was assessed based on the strict transient specifications.

| Control Strategy | Settling Time [s] | Overshoot [%] | Notes |
| :--- | :--- | :--- | :--- |
| **PID** | 0.86 | 53.4 | Sensitive to saturation. |
| **PID + AW** | 0.47 | 8.2 | Robust under saturation; good for large steps. |
| **SSC Placement (Nom.)** | 0.85 | 0 | Good nominal performance; low robustness. |
| **SSC + Integral** | 0.36 | 44.24 | High robustness; requires further tuning. |
| **LQR SRL (Nominal)** | 0.32 | 9.45 | Sensitive to high-frequency oscillations. |
| **LQR Bryson (Nominal)**| 0.43 | 9.39 | Improved beam stability. |
| **LQR FS (Robust), $q_{22}=1$** | 0.42 | 16.6 | **Best performance**: Successfully satisfies all constraints and handles resonance. |

The robust Frequency-Shaped LQR with intermediate penalization yielded the most balanced performance, while PID with anti-windup proved highly effective for simpler applications.
