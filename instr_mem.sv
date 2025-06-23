module instr_mem #(
    parameter MEM_SIZE = 2000   // Bellek boyutunu parametre olarak tanýmla
)(
    input logic [31:0] newpc,       // Yeni PC adresi
    output logic [31:0] instrF      // Çýktý olarak alýnan komut
);

    // Bellek boyutunu parametreye göre ayarlýyoruz
    logic [31:0] inst_memory [0:MEM_SIZE-1];

    // Bellek dosyasýndan komutlarý okuma
    initial $readmemh("imem.mem", inst_memory); // Assembly dosyasýný yükler


    // Komut alma iþlemi
//    always_comb begin
      assign  instrF = inst_memory[newpc[14:2]];  // Adresin son iki bitini maskeliyoruz (32-bit hizalama)
//    end

endmodule
