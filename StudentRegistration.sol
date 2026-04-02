// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StudentRegistration {
    address public owner;
    bool public registrationOpen;
    uint256 public totalRegistered;

    struct Student {
        string name;
        bool registered;
    }

    mapping(address => Student) public students;

    event StudentRegistered(address indexed studentAddress, string name);
    event RegistrationStatusChanged(bool isOpen);

    constructor() {
        owner = msg.sender;
        registrationOpen = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function setRegistrationStatus(bool _status) external onlyOwner {
        registrationOpen = _status;
        emit RegistrationStatusChanged(_status);
    }

    function register(string memory _name) public {
        require(registrationOpen, "Registration is closed.");
        require(bytes(_name).length > 0, "Name cannot be empty.");
        require(!students[msg.sender].registered, "You are already registered.");

        students[msg.sender] = Student(_name, true);
        totalRegistered++;

        emit StudentRegistered(msg.sender, _name);
    }

    function getMyStatus() external view returns (string memory, bool) {
        Student memory s = students[msg.sender];
        return (s.name, s.registered);
    }
}