module spi_slave (
    input wire sclk,       // שעון התקשורת (מהראספברי)
    input wire cs,         // צ'יפ סלקט (מסמן מתי מתחילים ומסיימים)
    input wire mosi,       // קו המידע (הביטים עצמם)
    output reg [9:0] pitch_val // המספר שיוצא החוצה לסינתיסייזר
);

    // אוגר (זיכרון) זמני לשמירת הביטים בזמן שהם נכנסים
    reg [9:0] shift_reg;

    // 1. תהליך הקליטה (Shifting)
    // בכל פעם שהשעון (sclk) עולה, אנחנו דוחפים ביט אחד פנימה
    always @(posedge sclk) begin
        if (cs == 0) begin // עובדים רק כשה-CS למטה (Active Low)
            shift_reg <= {shift_reg[8:0], mosi};
        end
    end

    // 2. תהליך העדכון (Latching)
    // רק כשה-CS עולה חזרה למעלה (סוף השידור), אנחנו מעדכנים את היציאה
    always @(posedge cs) begin
        pitch_val <= shift_reg;
    end

endmodule