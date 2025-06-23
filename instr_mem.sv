module instr_mem #(
    parameter MEM_SIZE = 2000   // Bellek boyutunu parametre olarak tan�mla
)(
    input logic [31:0] newpc,       // Yeni PC adresi
    output logic [31:0] instrF      // ��kt� olarak al�nan komut
);

    // Bellek boyutunu parametreye g�re ayarl�yoruz
    logic [31:0] inst_memory [0:MEM_SIZE-1];

    // Bellek dosyas�ndan komutlar� okuma
    initial $readmemh("imem.mem", inst_memory); // Assembly dosyas�n� y�kler


    // Komut alma i�lemi
//    always_comb begin
      assign  instrF = inst_memory[newpc[14:2]];  // Adresin son iki bitini maskeliyoruz (32-bit hizalama)
//    end

endmodule
