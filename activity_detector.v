module activity_detector (
    input clk,          // 50MHz
    input cs,           // Chip Select מהראסברי פאי 5
    output is_active    // יוצא ל-run_enable של השעון
);

    // 1. סנכרון האות (למניעת רעשים ומטא-סטביליות)
    reg cs_sync_0, cs_sync_1;
    always @(posedge clk) begin
        cs_sync_0 <= cs;
        cs_sync_1 <= cs_sync_0;
    end

    // 2. זיהוי ירידה (Falling Edge)
    reg cs_prev;
    always @(posedge clk) cs_prev <= cs_sync_1;
    wire edge_detected = (cs_prev == 1 && cs_sync_1 == 0);

    // 3. טיימר השהייה (Keep-alive)
    // 25,000,000 מחזורים = חצי שנייה בדיוק ב-50MHz
    reg [24:0] timeout_timer = 0;

    always @(posedge clk) begin
        if (edge_detected) begin
            timeout_timer <= 25000000; // טעינה מחדש בכל פעם שיש תקשורת
        end else if (timeout_timer > 0) begin
            timeout_timer <= timeout_timer - 1;
        end
    end

    // 4. יציאה: השעון רץ רק כשהטיימר פועל
    assign is_active = (timeout_timer > 0);

endmodule