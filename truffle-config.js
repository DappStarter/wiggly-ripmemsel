const HDWalletProvider = require('@truffle/hdwallet-provider');

let devUrl = 'http://127.0.0.1:7545/';
let mnemonic = 'jazz enroll supply suggest name rice place asset grace high sun subway';   
let testAccounts = [
"0xc95677835ca2cf8e659110f031e465e5b5c539723235351c0caa45d373496275",
"0x591c397b5b036114abe24befc46eb7a3338fd41c649043eab061c33fa81e36b1",
"0xe8610ce575384fa95cb7a16c40b2705a07398c84583dbe53f986af6f30863fb8",
"0xba79d332e02d1770e34d64145172670f0324fef9d2192f1d0d9df702d613dd7f",
"0xae8d0ae3f5206f2f47d42035543db2dea2f0e3d637cfad238bc21ed367a5ba83",
"0xc9e790088e86b697a111c0ed9db329fd84595e71b3502e943ce0f2034d9e6761",
"0xcd0101ca538c446d8da833a3c9e14d46db71eddfde938b118ff66dcbefd36cef",
"0xe49feae48e9e7477bb14fb781feb38589f70d180e8022ba94a0373774cf890b7",
"0x1822ebef10afdfa35ace6975cfa39a64aedb254314f8623a0b5f2b2f83e7e096",
"0xcec770477bde935dc416899b2b47a0f8679c93afae2803d641316afa369a5fd9"
];  

module.exports = {
  networks: {
    development: {
      url: devUrl,  // Required for DappStarter config generation
      provider: () => new HDWalletProvider(
                                      testAccounts,
                                      devUrl,           // provider url
                                      0,                // address index
                                      10,               // number of addresses
                                      true,             // share nonce
                                      `m/44'/60'/0'/0/` // wallet HD path
                                    ),
      network_id: '*'
    }
  },
  compilers: {
    solc: {
      version: '^0.5.11'
    }
  }
};
