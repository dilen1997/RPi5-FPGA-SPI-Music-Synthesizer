module stopwatch_display (
    input clk,          // שעון מערכת 50MHz
    input reset,        // מחובר ל-SW9
    input key_reset,    // מחובר ל-KEY0 (Active Low)
    input run_enable,   // מחובר ל-is_active (האות מהפאי)
    input pause,        // מחובר ל-SW8
    output [7:0] hex0, hex1, hex2, hex3
);

    reg [25:0] clk_count = 0;
    reg [3:0] sec_low=0, sec_high=0, min_low=0, min_high=0;

    // --- שלב 1: Synchronizer (מניעת Metastability) ---
    reg sync1, sync2;
    always @(posedge clk) begin
        sync1 <= run_enable;
        sync2 <= sync1;
    end

    // --- שלב 2: Debouncer (סינון רעשים וקפיצות סוויצ'ים) ---
    // סופר 1,000,000 מחזורי שעון (~20 מילי-שנייה) של יציבות
    reg [19:0] db_count = 0;
    reg run_clean = 0;

    always @(posedge clk) begin
        if (sync2 != run_clean) begin
            if (db_count >= 1000000) begin
                run_clean <= sync2;
                db_count <= 0;
            end else begin
                db_count <= db_count + 1;
            end
        end else begin
            db_count <= 0;
        end
    end

    // --- לוגיקת השעון המרכזית ---
    wire master_reset = reset || !key_reset; // איפוס מהסוויץ' או מהכפתור

    always @(posedge clk) begin
        if (master_reset) begin
            clk_count <= 0;
            sec_low <= 0; sec_high <= 0; min_low <= 0; min_high <= 0;
        end 
        else if (run_clean && !pause) begin // שימוש באות הנקי והמסונכרן
            if (clk_count >= 49999999) begin // ספירת שנייה אחת
                clk_count <= 0;
                if (sec_low == 9) begin
                    sec_low <= 0;
                    if (sec_high == 5) begin
                        sec_high <= 0;
                        if (min_low == 9) begin
                            min_low <= 0;
                            if (min_high == 5) min_high <= 0;
                            else min_high <= min_high + 1;
                        end else min_low <= min_low + 1;
                    end else sec_high <= sec_high + 1;
                end else sec_low <= sec_low + 1;
            end else clk_count <= clk_count + 1;
        end
    end

    // פונקציית פענוח לתצוגת 7-Segment
    function [7:0] decode (input [3:0] n);
        case (n)
            4'h0: decode = 8'hC0; 4'h1: decode = 8'hF9;
            4'h2: decode = 8'hA4; 4'h3: decode = 8'hB0;
            4'h4: decode = 8'h99; 4'h5: decode = 8'h92;
            4'h6: decode = 8'h82; 4'h7: decode = 8'hF8;
            4'h8: decode = 8'h80; 4'h9: decode = 8'h90;
            default: decode = 8'hFF;
        endcase
    endfunction

    assign hex0 = decode(sec_low);
    assign hex1 = decode(sec_high);
    assign hex2 = decode(min_low) & 8'h7F; // נקודה עשרונית בין דקות לשניות
    assign hex3 = decode(min_high);

endmodule