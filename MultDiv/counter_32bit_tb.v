module counter_5bit_tb();

    // Testbench variables
    reg clk, en, clr;
    wire [4:0] q;
    reg [4:0] expected_count;  // Variable to track the expected count

    // Instantiate the 32-bit counter module
    counter_32bit uut (
        .clk(clk),
        .en(en),
        .clr(clr),
        .q(q)
    );

    // Clock generation: 50 MHz clock (20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        en = 0;
        clr = 0;
        expected_count = 0;  // Start with count 0

        // Monitor values on console
        $monitor("Time = %0t | clk = %b | en = %b | clr = %b | q = %b | expected_count = %b", $time, clk, en, clr, q, expected_count);

        // Test case 1: Reset the counter
        clr = 1;
        #20 clr = 0;  // Release reset after a short delay

        // Test case 2: Enable the counter and let it count through all possible values
        en = 1;
        while (expected_count < 5'b11111) begin  // Loop through all possible counts (0 to 31)
            #20;  // Wait for a full clock cycle

            // Check if q matches the expected count
            if (q !== expected_count) begin
                $display("Error at time %0t: Expected %b but got %b", $time, expected_count, q);
            end else begin
                $display("Correct count at time %0t: %b", $time, q);
            end

            // Increment expected count for the next clock cycle
            expected_count = expected_count + 1;
        end

        // End simulation after reaching the final count
        $stop;
    end

endmodule

