VIEWS_ScheduleBusinessDaystoDueDate schedBatch = new VIEWS_ScheduleBusinessDaystoDueDate(); 

String schedule = '0 45 2 * * ?' ;  

System.schedule('Update Case Business Days to Due Date', schedule, schedBatch);  

  

VIEWS_ScheduleTaskBusinessDaystoDueDate schedTaskBatch = new VIEWS_ScheduleTaskBusinessDaystoDueDate(); 

String taskSchedule = '0 45 2 * * ?' ;  

System.schedule('Update Task Business Days to Due Date', taskSchedule, schedTaskBatch); 

  

VIEWS_CaseDaysSinceCreatedSchedulable schedBatchStatus = new VIEWS_CaseDaysSinceCreatedSchedulable();  

String scheduleStatus = '0 15 3 * * ?' ;  

System.schedule('Update Case Business Days Since Status has been New', scheduleStatus, schedBatchStatus);  

  

VIEWS_TaskDaysSinceCreatedSchedulable schedTaskBatchStatus = new VIEWS_TaskDaysSinceCreatedSchedulable();  

String taskScheduleStatus = '0 15 3 * * ?' ;  

System.schedule('Update Case Tasks Business Days Since Status has been New', taskScheduleStatus, schedTaskBatchStatus); 