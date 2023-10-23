set BASE=%~dp0
cd %BASE%

device_tool install msftap.inf msftap0
device_tool install msftap.inf msftap1
device_tool install msftap.inf msftap2
device_tool install msftap.inf msftap3

net stop npf
net start npf
