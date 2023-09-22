// SPDX-License-Identifier: MIT

// CONTRATO: 0x3D438176fB77b8ad9bb89dB8753850c543d86201

pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";

contract ExercicioTcc {

    Cliente private cliente;
    address private clientSender;
    ExercicioToken private exercicioToken;
    
    struct Cliente {
        string nomeCliente;
        string documentoCliente;
        string conta;
        address payable enderecoCliente; //0x0
    }

    event ReactToReceiveEther();

    constructor(string memory _nomeCliente, string memory _documentoCliente, string memory _conta) payable {

        clientSender = msg.sender;

        cliente = Cliente(_nomeCliente, _documentoCliente, _conta, payable(clientSender));

        // Preferi deixar fixado no deploy o endereço do token
        exercicioToken = ExercicioToken(0x89A2E711b2246B586E51f579676BE2381441A0d0);
    }

    function meuSaldo() public view returns(uint256) {
        return exercicioToken.balanceOf(address(this));
    }

    function gerarTokenParaEuCliente(uint256 _quantidade) public returns (bool) {
        return exercicioToken.mint(address(this), _quantidade);
    }

    // Plus::
    // a:
    function transfereTokensTerceiro(address _para, uint256 _valor) public returns (bool) {
        return exercicioToken.transfer(_para, _valor);
    }

    // b:
    function saldoCriptomoedaNativa() public view returns (uint){
        return address(this).balance;
    }

    // c:
    function transfereCriptomoedaNativa(address _para, uint256 _valor) public payable {
        require(saldoCriptomoedaNativa() <= _valor, "Saldo atual insuficiente");
        (bool ok, ) = _para.call{value: _valor}(abi.encodeWithSignature("takeMoney()"));
        require(ok, "transfer failed");
    }

    receive() external payable {
        emit ReactToReceiveEther();
    }
}
