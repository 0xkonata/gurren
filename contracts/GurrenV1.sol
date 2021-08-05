pragma solidity ^0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./ITemplateContract.sol";

/**
 * @author 0xMotoko
 * @title BulksaleV1
 * @notice Minimal Proxy Platform-ish fork of the HegicInitialOffering.sol
 */
contract GurrenV1 is ITemplateContract, ReentrancyGuard {
    /*
        ==========================================
        === Template Idiom Declarations Begins ===
        ==========================================
    */
    bool initialized = false;

    address public constant factory = address(0x5FbDB2315678afecb367f032d93F642f64180aa3);

    /*
        You can't use constructor
        because the minimal proxy is really minimal.
        
        Proxy is minimal
        = no constructor
        = You can't access the Proxy constructor's SSTORE slot
        from implementation constructor's SLOAD slot.

        === DEFINE YOUR OWN ARGS BELOW ===

    */

    /* States in the deployment initialization */
    public bytes32 gurrenId;
    public address owner;
    /* States end */
    
    struct Args {
    }
    function initialize(bytes memory abiBytes) public onlyOnce onlyFactory override returns (bool) {
        Args memory args = abi.decode(abiBytes, (Args));

        owner = msg.sender;
        gurrenId = _rand();

        emit Initialized(abiBytes);
        initialized = true;
        return true;
    }
    modifier onlyOnce {
        require(!initialized, "This contract has already been initialized");
        _;
    }
    modifier onlyFactory {
        require(msg.sender == factory, "You are not the Factory.");
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner.");
        _;
    }
    /*
        ========================================
        === Template Idiom Declarations Ends ===
        ========================================
    */




    /*
        Let's go core logics :)
    */
    StatusType status;
    public bytes32 genome;
    public uint tokenId;
    public bool isLegendary = false;

    struct StatusType {
        uint HP;
        uint MP;
        uint STR;
        uint VIT;
        uint DEF;
        uint INT;
        uint RES;
        uint DEX;
        uint AGI;
        uint LUK;
        uint Lv;
        uint EXP;
        uint TLM;
    }
    struct FuseArgs {
        uint tokenId;
    }
    event Received(address indexed account, uint amount);
    event Fused(address indexed account, uint256 indexed tokenId, uint256 indexed gurrenId, bytes32 genome);


    function fuse(FuseArg args) public onlyOwner {
        tokenId = args.tokenId;
        genome = keccak256(abi.encodePacked(tokenId, gurrenId));
        _determineStatus();
        emit Fused(msg.sender, tokenId, gurrenId, genome)
    }
    function _rand() internal {
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
    }
    function _determineStatus() internal {
        _checkLegendaryNFTs();
        status = _tickStatus();
    }
    function _checkLegendaryNFTs() internal {
        if(gurrenFactory.legendaryDictionary()[tokenId], "") {
            isLegendary = true;
        }
    }

    function getoff public onlyOwner {
        _remove();
    }
    function _remove() internal {
        tokenId = uint(0);
        genome = bytes32(0);
        status = StatusType(0);
    }
    function _tickStatus() internal {
        StatusType memory s = status;        
        bytes32 r = _rand();

        return StatusType(
            s.HP + r*uint(genome[0:2]) * (isLegendary) ? 2 : 1,
            s.MP + r*uint(genome[2:4]) * (isLegendary) ? 2 : 1,
            s.STR + r*uint(genome[4:6]) * (isLegendary) ? 2 : 1,
            s.VIT + r*uint(genome[6:8]) * (isLegendary) ? 2 : 1,
            s.DEF + r*uint(genome[8:10]) * (isLegendary) ? 2 : 1,
            s.INT + r*uint(genome[10:12]) * (isLegendary) ? 2 : 1,
            s.RES + r*uint(genome[12:14]) * (isLegendary) ? 2 : 1,
            s.DEX + r*uint(genome[14:16]) * (isLegendary) ? 2 : 1,
            s.AGI + r*uint(genome[16:18]) * (isLegendary) ? 2 : 1,
            s.LUK + r*uint(genome[18:20]) * (isLegendary) ? 2 : 1,
            s.Lv + 1,
            s.EXP,
            s.TLM
        );
    }
    function _checkLevelUp() internal {
        if (status.EXP > 1e21) {
            status = _tickStatus();
        } else if(status.EXP > 3e15 + 2e14) {
            status = _tickStatus();
        } else if(status.EXP > 2e15 + 5e14) {
            status = _tickStatus();
        } else if(status.EXP > 1e15) {
            status = _tickStatus();
        }
    }


    receive() external payable {
        status.EXP += msg.value;
        status.TLM += msg.value;
        _checkLevelUp();
        emit Received(msg.sender, msg.value);
    }

}