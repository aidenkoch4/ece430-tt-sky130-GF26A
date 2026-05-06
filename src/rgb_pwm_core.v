// Aiden Koch
// 5/5/2026
// Version 1

module rgb_pwm_core #(
    parameter WIDTH = 6
)(
    input  wire clk,
    input  wire rst_n,

    input  wire [4:0] value,
    input  wire [2:0] mode,

    output reg pwm_r,
    output reg pwm_g,
    output reg pwm_b
);

    // -------------------------
    // Registers
    // -------------------------
    reg [WIDTH-1:0] duty_r, duty_g, duty_b;
    reg [3:0] speed_reg;   // 0–15 control

    // -------------------------
    // Clock divider
    // -------------------------
    reg [15:0] clk_div;

    wire slow_clk = clk_div[speed_reg];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 0;
        else
            clk_div <= clk_div + 1;
    end

    // -------------------------
    // PWM counter
    // -------------------------
    reg [WIDTH-1:0] counter;

    always @(posedge slow_clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // -------------------------
    // Mode-based updates
    // -------------------------
    always @(posedge slow_clk or negedge rst_n) begin
        if (!rst_n) begin
            duty_r   <= 0;
            duty_g   <= 0;
            duty_b   <= 0;
            speed_reg <= 4'd4; // default visible speed
        end else begin
            case (mode)
                3'b000: duty_r <= value;
                3'b001: duty_g <= value;
                3'b010: duty_b <= value;
                3'b011: speed_reg <= value[3:0];
                default: ;
            endcase
        end
    end

    // -------------------------
    // PWM outputs
    // -------------------------
    always @(posedge slow_clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_r <= 0;
            pwm_g <= 0;
            pwm_b <= 0;
        end else begin
            pwm_r <= (counter < duty_r);
            pwm_g <= (counter < duty_g);
            pwm_b <= (counter < duty_b);
        end
    end

endmodule
