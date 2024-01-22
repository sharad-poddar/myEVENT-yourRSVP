//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
contract Web3rsvp{

    ///@dev state variables
    struct createEvent{
        bytes32 eventId;
        string eventDataCID;
        address eventOwner;
        uint256 eventTimestamp;
        uint256 deposit;
        uint256 maxCapacity;
        address[] confirmedRSVP;
        address[] claimedRSVP;
        address[] eventAttendee;
        bool paidOut;
    }

    mapping(bytes32 => createEvent) public idToEvent;

    //events
    event newEventCreated(bytes32 eventId,
        string eventDataCID,
        address eventOwner,
        uint256 eventTimestamp,
        uint256 deposit,
        uint256 maxCapacity,
        address[] confirmedRSVP,
        address[] claimedRSVP,
        address[] eventAttendee,
        bool paidOut);
    event rsvpConfirmed(bytes32 eventId, address person);
    event eventAttended(bytes32 eventId, address[] person);
    event rsvpClaimed(bytes32 eventId, address person, uint256 deposit);
    event DepositsPaidOut(bytes32 eventId);


    function createNewEvent(uint256 _timestamp, uint256 _deposit, uint256 _maxCapacity, string calldata _CID) external {
        
        //1. creating id
        bytes32 eventId = keccak256(abi.encodePacked(msg.sender, address(this), _timestamp, _deposit, _maxCapacity));
        address[] memory confirmedRSVP;
        address[] memory claimedRSVP;
        address[] memory eventAttendee;

        idToEvent[eventId] = createEvent(eventId, _CID, msg.sender, _timestamp, _deposit, _maxCapacity, confirmedRSVP, claimedRSVP, eventAttendee, false);

        //2. event must start same time on creating it
        require(idToEvent[eventId].eventTimestamp != 0,'Event is already registered');
        emit newEventCreated(eventId, _CID, msg.sender, _timestamp, _deposit, _maxCapacity, confirmedRSVP, claimedRSVP, eventAttendee, false);
    }



    // persons reseving spot by depositing, chainging to onchain data
    function createNewRsvps(bytes32 _eventId) external payable{
        //1. getting event
        createEvent storage myEvent = idToEvent[_eventId];
        //2. required deposit and not strted yet
        require(msg.value == myEvent.deposit,'please send sufficent fund for RSVP');
        require(block.timestamp < myEvent.eventTimestamp,'Event has already been started');

        //3. if person is not a new one then revert back
        for(uint8 i=0;i<myEvent.confirmedRSVP.length;i++){
            require(myEvent.confirmedRSVP[i] != msg.sender,'you are already rsvp confirmed');
        }

        //4. adding to list
        myEvent.confirmedRSVP.push(payable(msg.sender));
        emit rsvpConfirmed(_eventId, msg.sender);
    }



    //attendes will get their deposit back
    function confirmAttendees(bytes32 _eventId, address _attendee) internal{
        //1. getting event
        createEvent storage myEvent = idToEvent[_eventId];
        
        //2. checking if person claimed rsvp or not
        for (uint8 i = 0; i < myEvent.claimedRSVP.length; i++) {
            require(myEvent.claimedRSVP[i] != _attendee, "ALREADY CLAIMED");
        }

        //3. event reserve 
        require(myEvent.paidOut == false, "ALREADY PAID OUT");

        //4. adding the person to claimedRSVP list
        myEvent.claimedRSVP.push(_attendee);
        (bool sent,) = _attendee.call{value: myEvent.deposit}("");

        //5. if txn failed then pop the person
        if(!sent){
            myEvent.claimedRSVP.pop();
        }

        require(sent,"depoist of attendee is failed to transact back to attendee");
        emit rsvpClaimed(_eventId, _attendee, myEvent.deposit);
    }




    function attendPersonList(bytes32 _eventId, address _person) external{
        //1. get event
        createEvent storage myEvent = idToEvent[_eventId];
        //2. onlyOwner
        require(msg.sender == myEvent.eventOwner,'you are not owner');        
        //3. there must be no owner in RSVP lsit
        require(myEvent.eventOwner != _person,'owner');
        
        //4. checking if the person is in RSVP list or not
        address rsvpConfirm;
        for(uint8 i=0;i<myEvent.confirmedRSVP.length;i++){
            if(myEvent.confirmedRSVP[i] == _person){
                rsvpConfirm = _person;
            }
        }
        require(rsvpConfirm == _person,"your RSVP is not confirmed!");

        //5. checking if the person adding to the list is unique or not
        for(uint8 i=0;i<myEvent.eventAttendee.length;i++){
            require(myEvent.eventAttendee[i] != _person,'already added to attende list');
        }

        //6. adding attendee to attended list
        myEvent.eventAttendee.push(_person);
        emit eventAttended(_eventId, myEvent.eventAttendee);
    }




    // ending an eventId and attendee address list
    function confirmAttendee(bytes32 _eventId) external{
        createEvent memory myEvent = idToEvent[_eventId];
        require(block.timestamp >= myEvent.eventTimestamp, 'event has not started yet' );
        
        require(msg.sender == myEvent.eventOwner, "NOT AUTHORIZED");

        for(uint8 i=0;i<myEvent.eventAttendee.length;i++){
            confirmAttendees(_eventId, myEvent.eventAttendee[i]);
        }
    }



    ///@notice money left after reserve money given to attendee
    function withdrawUnclaimedDeposits(bytes32 _eventId) external{
        
        //1. getting an event
        createEvent memory myEvent = idToEvent[_eventId];
        //2. onlyOwner
        require(myEvent.eventOwner == msg.sender,'who are you!!');
        //3. reseve empty or not
        require(!myEvent.paidOut, "ALREADY PAID");
        //4. after the 7 days of event
        require(block.timestamp >= myEvent.eventTimestamp + 7 days,"Too Early");
        //5. number of non-attendes
        uint256 unclaimedPersons = myEvent.confirmedRSVP.length - myEvent.claimedRSVP.length;
        
        //6. money sending to owner of event
        uint256 unclaimedAmount = unclaimedPersons * myEvent.deposit;
        (bool sent, ) = myEvent.eventOwner.call{value: unclaimedAmount}("");
        require(sent,'unclaimed amount txn to owner failed');
        myEvent.paidOut = true;

        emit DepositsPaidOut(_eventId);
    } 


}