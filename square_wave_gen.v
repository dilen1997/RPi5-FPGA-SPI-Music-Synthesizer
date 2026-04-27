module square_wave_gen (
    input clk,              // שעון מערכת 50MHz
    input enable,           // מחובר ל-is_active מהדיטקטור
    input pause,            // כניסה חדשה לסוויץ' 8
    input [9:0] pitch_val,  // הערך שמגיע מהפאי (0-1023)
    output reg wave_out     // היציאה לרמקול
);

    integer counter;
    
    // חישוב הגבול לספירה לפי התדר המבוקש
    // ככל ש-pitch_val גדול יותר, limit קטן יותר והתדר גבוה יותר
    wire [31:0] limit = 200000 - (pitch_val * 150);

    initial begin
        counter = 0;
        wave_out = 0;
    end

    always @(posedge clk) begin
        // התנאי להפעלת הצליל: יש אישור נגינה, אין פאוז ויש ערך תדר
        if (enable == 1 && pause == 0 && pitch_val > 0) begin
            if (counter >= limit) begin
                counter <= 0;
                wave_out <= ~wave_out; // הפיכת האות ליצירת גל ריבועי
            end else begin
                counter <= counter + 1;
            end
        end 
        else begin
            // אם המנגינה נעצרה או שיש פאוז - שקט מוחלט ואיפוס
            wave_out <= 0;
            counter <= 0;
        end
    end

endmodule