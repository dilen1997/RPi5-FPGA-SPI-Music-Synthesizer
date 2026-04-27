module led_dancer (
    input clk,
    input [9:0] pitch_val,
    input [3:0] brightness, // חבר לסוויצ'ים SW[3:0]
    output [9:0] ledr
);
    // לוגיקת PWM לעוצמת האור
    reg [3:0] pwm_count = 0;
    always @(posedge clk) pwm_count <= pwm_count + 1;
    wire light_on = (pwm_count < brightness);

    // לוגיקת הריקוד
    reg [9:0] dance_pattern;
    always @(*) begin
        dance_pattern = 10'b0;
        if (pitch_val > 150) dance_pattern[0] = 1;
        if (pitch_val > 250) dance_pattern[1] = 1;
        if (pitch_val > 300) dance_pattern[2] = 1;
        if (pitch_val > 350) dance_pattern[3] = 1;
        if (pitch_val > 400) dance_pattern[4] = 1;
        if (pitch_val > 450) dance_pattern[5] = 1;
        if (pitch_val > 500) dance_pattern[6] = 1;
        if (pitch_val > 550) dance_pattern[7] = 1;
        if (pitch_val > 600) dance_pattern[8] = 1;
        if (pitch_val > 650) dance_pattern[9] = 1;
    end

    // שילוב העוצמה עם הריקוד
    assign ledr = light_on ? dance_pattern : 10'b0;
endmodule