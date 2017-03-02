configuration Name
{
    # 用户可以计算表达式，以获取节点列表
    # 例如: $AllNodes.Where("Role -eq Web").NodeName
    node ("Node1","Node2","Node3")
    {
        # 调用资源提供程序
        # 例如: WindowsFeature, File
        WindowsFeature Web-App-Dev
        {
           Ensure = "Present"
           Name = "Web-App-Dev"
        }
        WindowsFeature Web-Net-Ext45
        {
           Ensure = "Present"
           Name = "Web-Net-Ext45"
        }
        WindowsFeature Web-Asp-Net45
        {
           Ensure = "Present"
           Name = "Web-Asp-Net45"
        }
        WindowsFeature Web-ISAPI-Ext
        {
           Ensure = "Present"
           Name = "Web-ISAPI-Ext"
        }
        WindowsFeature Web-ISAPI-Filter
        {
           Ensure = "Present"
           Name = "Web-ISAPI-Filter"
        }
        WindowsFeature Web-WebSockets
        {
           Ensure = "Present"
           Name = "Web-WebSockets"
        }
WindowsFeature Web-Mgmt-Tools
        {
           Ensure = "Present"
           Name = "Web-Mgmt-Tools"
        }
WindowsFeature Web-Mgmt-Console
        {
           Ensure = "Present"
           Name = "Web-Mgmt-Console"
        }
WindowsFeature Web-Scripting-Tools
        {
           Ensure = "Present"
           Name = "Web-Scripting-Tools"
        }
WindowsFeature Web-Mgmt-Service
        {
           Ensure = "Present"
           Name = "Web-Mgmt-Service"
        }      
    }
}