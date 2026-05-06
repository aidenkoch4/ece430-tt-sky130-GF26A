/*
 * Copyright (c) 2024 Aiden Koch
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module project (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire clk,
    input  wire rst_n
);

    wire [2:0] mode  = ui_in[7:5];
    wire [4:0] value = ui_in[4:0];

    wire pwm_r, pwm_g, pwm_b;

    rgb_pwm_core core (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .value(value),
        .pwm_r(pwm_r),
        .pwm_g(pwm_g),
        .pwm_b(pwm_b)
    );

    assign uo_out[0] = pwm_r;
    assign uo_out[1] = pwm_g;
    assign uo_out[2] = pwm_b;
    assign uo_out[7:3] = 5'b0;

endmodule
