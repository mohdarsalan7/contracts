// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Todo{
    struct Task{
        uint id;
        string name;
        string date;
    }

    address owner;
    Task task;
    mapping(uint => Task) tasks; // get all Tasks
    uint taskId = 1; // taskId

    event taskDelete(uint taskId);
    event taskUpdate(uint taskId, string name ,string date);

    //check taskId is valid
    modifier checkId(uint id){
        require(id!=0&& id<taskId,"Invalid Id");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createTask(string calldata _taskname, string calldata _date) public {
        tasks[taskId] = Task(taskId, _taskname, _date);
        taskId++;
    }

    function getTaskById(uint _taskId) checkId(_taskId) public view returns (Task memory){
        return tasks[_taskId];
    }

    function getAllTasks () public view returns (Task[] memory){
        Task[] memory taskList = new Task[](taskId-1);
        for(uint i=0;i<taskId-1;i++){
            taskList[i] = tasks[i+1];
        }
        return taskList ;
    }

    function updateTask(uint _taskId, string calldata _name, string calldata _date) checkId(_taskId) public{
        tasks[_taskId].name = _name;
        tasks[_taskId].date = _date;
        emit taskUpdate(_taskId,tasks[_taskId].name ,tasks[_taskId].date);
    }

    function deleteTask(uint _taskId) checkId(_taskId) public {
      delete tasks[_taskId];
      emit taskDelete(_taskId);
    }   
}