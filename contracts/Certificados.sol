pragma solidity ^0.8.0;

contract Certificados {

    // Owner: única dirección autorizada a registrar/revocar
    address public owner;

    struct Certificado {
        string  nombre;
        string  codigo;
        uint256 fechaEmision;  // timestamp UNIX
        bool    valido;
        address emisor;        // quién registró (auditable)
    }

    // Almacenamiento principal: codigo → Certificado
    mapping(string => Certificado) private certificados;

    // Evento emitido en cada registro (indexable off-chain)
    event CertificadoRegistrado(
        string indexed codigo,
        string  nombre,
        uint256 fechaEmision,
        address emisor
    );

    // Evento de revocación
    event CertificadoRevocado(string indexed codigo, address revocadoPor);

    // Modificador: solo el owner puede ejecutar la función
    modifier onlyOwner() {
        require(msg.sender == owner, "Solo el emisor autorizado puede operar");
        _;
    }

    // Modificador: el certificado debe existir
    modifier existe(string memory _codigo) {
        require(bytes(certificados[_codigo].codigo).length > 0, "Certificado no encontrado");
        _;
    }

    constructor() {
        owner = msg.sender;  // Deployer = institución emisora
    }

    /**
     * @notice Registra un certificado nuevo en blockchain
     * @param _codigo  Código único del certificado
     * @param _nombre  Nombre del titular
     */
    function registrar(
        string memory _codigo,
        string memory _nombre
    ) public onlyOwner {
        // Evita sobreescritura de certificados ya emitidos
        require(
            bytes(certificados[_codigo].codigo).length == 0,
            "Codigo ya registrado"
        );

        certificados[_codigo] = Certificado({
            nombre:       _nombre,
            codigo:       _codigo,
            fechaEmision: block.timestamp,
            valido:       true,
            emisor:       msg.sender
        });

        emit CertificadoRegistrado(_codigo, _nombre, block.timestamp, msg.sender);
    }

    /**
     * @notice Verifica si un certificado es válido
     * @param _codigo  Código del certificado a consultar
     * @return bool    true si existe y está vigente
     */
    function verificar(
        string memory _codigo
    ) public view existe(_codigo) returns (bool) {
        return certificados[_codigo].valido;
    }

    /**
     * @notice Obtiene todos los datos de un certificado
     */
    function obtenerCertificado(
        string memory _codigo
    ) public view existe(_codigo) returns (
        string memory nombre,
        uint256 fechaEmision,
        bool valido,
        address emisor
    ) {
        Certificado memory c = certificados[_codigo];
        return (c.nombre, c.fechaEmision, c.valido, c.emisor);
    }

    /**
     * @notice Revoca un certificado (solo owner)
     */
    function revocar(
        string memory _codigo
    ) public onlyOwner existe(_codigo) {
        certificados[_codigo].valido = false;
        emit CertificadoRevocado(_codigo, msg.sender);
    }
}
