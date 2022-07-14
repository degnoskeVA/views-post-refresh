//Script #8 GAO Setup

System.schedule('Send Case Task Notification Updates','0 0 0 * * ?', new Views_GAO_ScheduleCaseTaskNotifications());
System.schedule('Send Recommendation Update Notification Updates','0 0 0 * * ?', new Views_GAO_ScheduleRecUpdateNotif());