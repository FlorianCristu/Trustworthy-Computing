# Minimal sandbox launcher WITH mapped folder

param(
    [string]$FilePath
)
$HostFolder = Split-Path -Parent $FilePath
$ExeName = Split-Path -Leaf $FilePath
$WsbPath = "$PSScriptRoot\SandboxTest.wsb"

$wsbContent = @"
<Configuration>
  <vGPU>Disable</vGPU>
  <Networking>Disable</Networking>

  <MappedFolders>
    <MappedFolder>
      <HostFolder>$HostFolder</HostFolder>
      <SandboxFolder>C:\SandboxApp</SandboxFolder>
      <ReadOnly>false</ReadOnly>
    </MappedFolder>
  </MappedFolders>

  <LogonCommand>
   <Command>cmd /c cd /d C:\SandboxApp &amp;&amp; $ExeName &lt; NUL &gt; auto_output.txt</Command>
  </LogonCommand>

</Configuration>
"@
$wsbContent | Out-File -FilePath $WsbPath -Encoding utf8 -Force
Start-Process $WsbPath