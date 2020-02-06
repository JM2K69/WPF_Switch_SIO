$ProgressPreference = 'SilentlyContinue'
[System.void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 
[System.void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      
[System.void][System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll') 
[System.void][System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 
[System.void][System.Reflection.Assembly]::LoadFrom("assembly\ControlzEx.dll")     
[System.void][System.Reflection.Assembly]::LoadFrom("assembly\Microsoft.Xaml.Behaviors.dll")      


Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

[System.Windows.Forms.Application]::EnableVisualStyles()


#########################################################################
#                        Load Main Panel                                #
#########################################################################

$Global:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition

function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}
$XamlMainWindow=LoadXaml($pathPanel+"\main.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)

# ===============================================
# ======== Load TemplateWindow ==================
# ===============================================
$xamlDialog  = LoadXaml($pathPanel+"\Dialog\Dialog.xaml")
$read=(New-Object System.Xml.XmlNodeReader $xamlDialog)
$DialogForm=[Windows.Markup.XamlReader]::Load( $read )

# Create a new Dialog attached to Main Form 
$CustomDialog         = [MahApps.Metro.Controls.Dialogs.CustomDialog]::new($Form)

# Specifiy the content of the Custom dialog with the new 
# dialog form created.
$CustomDialog.AddChild($DialogForm)
$settings             = [MahApps.Metro.Controls.Dialogs.MetroDialogSettings]::new()
$settings.ColorScheme = [MahApps.Metro.Controls.Dialogs.MetroDialogColorScheme]::Theme

$WPF_dialgInterface  = $DialogForm.FindName("dialgInterface")
$WPF_dialgPortStatus      = $DialogForm.FindName("dialgPortStatus")
$WPF_dialgMessage        = $DialogForm.FindName("dialgMessage") 
$WPF_Close        = $DialogForm.FindName("Close")


#########################################################################
#                       Functions       								#
#########################################################################
$SwitchModel = $WPF_SwitchModel.SelectionBoxItem
$XamlMainWindow.SelectNodes("//*[@Name]") | %{
    try {Set-Variable -Name "$("WPF_"+$_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable *WPF*
}
  #Get-FormVariables

#########################################################################
#                       DATA       						       		    #
#########################################################################
$FileHP = $pathPanel+"\Current\hp.xml"
$FileCisco = $pathPanel+"\Current\cisco.xml"

$xmlHP = [xml](Get-Content $FileHP)
$xmlCisco = [xml](Get-Content $FileCisco)

Function editRow($rowObj){ 
    

    # Enable inputs
    $WPF_dialgInterface.IsEnabled 		= $false
    $WPF_dialgPortStatus.IsEnabled      = $true
    $WPF_dialgMessage.IsEnabled         = $true

    # fill content with the selected object
	$WPF_dialgInterface.Text = $rowObj.Interface
	
	switch ($rowObj.Status) {
		'ON' { $WPF_dialgPortStatus.SelectedIndex = 1}
		'OFF'{ $WPF_dialgPortStatus.SelectedIndex = 0 }
		'ACC'{ $WPF_dialgPortStatus.SelectedIndex = 2}
		'TRK'{ $WPF_dialgPortStatus.SelectedIndex = 3}
		'AGG'{ $WPF_dialgPortStatus.SelectedIndex = 4}
		Default {}
	}

	$WPF_dialgMessage.Text       = $rowObj.Message

    # Show custom dialog form
    [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMetroDialogAsync($Form, $CustomDialog, $settings)    

}

[System.Windows.RoutedEventHandler]$EventonDataGrid = {

    $button =  $_.OriginalSource.Name

    $Script:resultObj = $WPF_Datagrid.CurrentItem

    If ($button -match "Edit" ){    
        editRow -rowObj $resultObj
    }
   

}
$WPF_Datagrid.AddHandler([System.Windows.Controls.Button]::ClickEvent, $EventonDataGrid)

function New-Statistic {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		$Value,
		[Parameter(Mandatory=$true)]
		$Message,
		[Parameter(Mandatory=$true)]
        [ValidateSet("HP", "Cisco")]
        $TypeSwicth
		
	)
		switch ($TypeSwicth) {
			'HP' 
			{ 
				switch ($Value) 
				{
				'ETH01'{ $WPF_Eth01.ToolTip = "$Message" }
				'ETH02'{ $WPF_Eth02.ToolTip = "$Message" }
				'ETH03'{ $WPF_Eth03.ToolTip = "$Message" }
				'ETH04'{ $WPF_Eth04.ToolTip = "$Message" }
				'ETH05'{ $WPF_Eth05.ToolTip = "$Message" }
				'ETH06'{ $WPF_Eth06.ToolTip = "$Message" }
				'ETH07'{ $WPF_Eth07.ToolTip = "$Message" }
				'ETH08'{ $WPF_Eth08.ToolTip = "$Message" }
				'ETH09'{ $WPF_Eth09.ToolTip = "$Message" }
				'ETH10'{ $WPF_Eth10.ToolTip = "$Message" }
				'ETH11'{ $WPF_Eth11.ToolTip = "$Message" }
				'ETH12'{ $WPF_Eth12.ToolTip = "$Message" }
				'ETH13'{ $WPF_Eth13.ToolTip = "$Message" }
				'ETH14'{ $WPF_Eth14.ToolTip = "$Message" }
				'ETH15'{ $WPF_Eth15.ToolTip = "$Message" }
				'ETH16'{ $WPF_Eth16.ToolTip = "$Message" }
				'ETH17'{ $WPF_Eth17.ToolTip = "$Message" }
				'ETH18'{ $WPF_Eth18.ToolTip = "$Message" }
				'ETH19'{ $WPF_Eth19.ToolTip = "$Message" }
				'ETH20'{ $WPF_Eth20.ToolTip = "$Message" }
				'ETH21'{ $WPF_Eth21.ToolTip = "$Message" }
				'ETH22'{ $WPF_Eth22.ToolTip = "$Message" }
				'ETH23'{ $WPF_Eth23.ToolTip = "$Message" }
				'ETH24'{ $WPF_Eth24.ToolTip = "$Message" }
				}
			}
			'Cisco'
			{
				switch ($Value) 
				{
				'ETH01'{ $WPF_CEth01.ToolTip = "$Message" }
				'ETH02'{ $WPF_CEth02.ToolTip = "$Message" }
				'ETH03'{ $WPF_CEth03.ToolTip = "$Message" }
				'ETH04'{ $WPF_CEth04.ToolTip = "$Message" }
				'ETH05'{ $WPF_CEth05.ToolTip = "$Message" }
				'ETH06'{ $WPF_CEth06.ToolTip = "$Message" }
				'ETH07'{ $WPF_CEth07.ToolTip = "$Message" }
				'ETH08'{ $WPF_CEth08.ToolTip = "$Message" }
				'ETH09'{ $WPF_CEth09.ToolTip = "$Message" }
				'ETH10'{ $WPF_CEth10.ToolTip = "$Message" }
				'ETH11'{ $WPF_CEth11.ToolTip = "$Message" }
				'ETH12'{ $WPF_CEth12.ToolTip = "$Message" }
				'ETH13'{ $WPF_CEth13.ToolTip = "$Message" }
				'ETH14'{ $WPF_CEth14.ToolTip = "$Message" }
				'ETH15'{ $WPF_CEth15.ToolTip = "$Message" }
				'ETH16'{ $WPF_CEth16.ToolTip = "$Message" }
				'ETH17'{ $WPF_CEth17.ToolTip = "$Message" }
				'ETH18'{ $WPF_CEth18.ToolTip = "$Message" }
				'ETH19'{ $WPF_CEth19.ToolTip = "$Message" }
				'ETH20'{ $WPF_CEth20.ToolTip = "$Message" }
				'ETH21'{ $WPF_CEth21.ToolTip = "$Message" }
				'ETH22'{ $WPF_CEth22.ToolTip = "$Message" }
				'ETH23'{ $WPF_CEth23.ToolTip = "$Message" }
				'ETH24'{ $WPF_CEth24.ToolTip = "$Message" }
				'Gi0/0'{ $WPF_CGI00.ToolTip = "$Message" }
				'Gi0/1'{ $WPF_CGI01.ToolTip = "$Message" }
		
			}
			}
			Default {}
		}
		
	
}

function New-PortActivity {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		$Value,
		[Parameter(Mandatory=$true)]
		[ValidateSet("ON", "OFF","ACC","TRK","AGG")]
		$Status,
		[Parameter(Mandatory=$true)]
        [ValidateSet("HP", "Cisco")]
        $TypeSwicth

		
	)
begin{
	switch ($Status) {
		'ON' 	{ $Status_Port = "#FF3EC220" }
		'OFF' 	{ $Status_Port = "#FF303030" }
		'ACC'	{ $Status_Port = "#FFCF184F" }
		'TRK'	{ $Status_Port = "#E7E9790F" }
		'AGG' 	{ $Status_Port = "#E764A9F3" }
		Default {}
	}
 }

	process{
		
		switch ($TypeSwicth) 
		{
			'HP' 
			{
				switch ($Value) 
				{
					'ETH01'{ $WPF_Eth01.Fill = "$Status_Port" }
					'ETH02'{ $WPF_Eth02.Fill = "$Status_Port" }
					'ETH03'{ $WPF_Eth03.Fill = "$Status_Port" }
					'ETH04'{ $WPF_Eth04.Fill = "$Status_Port" }
					'ETH05'{ $WPF_Eth05.Fill = "$Status_Port" }
					'ETH06'{ $WPF_Eth06.Fill = "$Status_Port" }
					'ETH07'{ $WPF_Eth07.Fill = "$Status_Port" }
					'ETH08'{ $WPF_Eth08.Fill = "$Status_Port" }
					'ETH09'{ $WPF_Eth09.Fill = "$Status_Port" }
					'ETH10'{ $WPF_Eth10.Fill = "$Status_Port" }
					'ETH11'{ $WPF_Eth11.Fill = "$Status_Port" }
					'ETH12'{ $WPF_Eth12.Fill = "$Status_Port" }
					'ETH13'{ $WPF_Eth13.Fill = "$Status_Port" }
					'ETH14'{ $WPF_Eth14.Fill = "$Status_Port" }
					'ETH15'{ $WPF_Eth15.Fill = "$Status_Port" }
					'ETH16'{ $WPF_Eth16.Fill = "$Status_Port" }
					'ETH17'{ $WPF_Eth17.Fill = "$Status_Port" }
					'ETH18'{ $WPF_Eth18.Fill = "$Status_Port" }
					'ETH19'{ $WPF_Eth19.Fill = "$Status_Port" }
					'ETH20'{ $WPF_Eth20.Fill = "$Status_Port" }
					'ETH21'{ $WPF_Eth21.Fill = "$Status_Port" }
					'ETH22'{ $WPF_Eth22.Fill = "$Status_Port" }
					'ETH23'{ $WPF_Eth23.Fill = "$Status_Port" }
					'ETH24'{ $WPF_Eth24.Fill = "$Status_Port" }
					Default {}
				}
			}
			'Cisco'
			{
				switch ($Value) {
					'ETH01'{ $WPF_CEth01.Fill = "$Status_Port" }
					'ETH02'{ $WPF_CEth02.Fill = "$Status_Port" }
					'ETH03'{ $WPF_CEth03.Fill = "$Status_Port" }
					'ETH04'{ $WPF_CEth04.Fill = "$Status_Port" }
					'ETH05'{ $WPF_CEth05.Fill = "$Status_Port" }
					'ETH06'{ $WPF_CEth06.Fill = "$Status_Port" }
					'ETH07'{ $WPF_CEth07.Fill = "$Status_Port" }
					'ETH08'{ $WPF_CEth08.Fill = "$Status_Port" }
					'ETH09'{ $WPF_CEth09.Fill = "$Status_Port" }
					'ETH10'{ $WPF_CEth10.Fill = "$Status_Port" }
					'ETH11'{ $WPF_CEth11.Fill = "$Status_Port" }
					'ETH12'{ $WPF_CEth12.Fill = "$Status_Port" }
					'ETH13'{ $WPF_CEth13.Fill = "$Status_Port" }
					'ETH14'{ $WPF_CEth14.Fill = "$Status_Port" }
					'ETH15'{ $WPF_CEth15.Fill = "$Status_Port" }
					'ETH16'{ $WPF_CEth16.Fill = "$Status_Port" }
					'ETH17'{ $WPF_CEth17.Fill = "$Status_Port" }
					'ETH18'{ $WPF_CEth18.Fill = "$Status_Port" }
					'ETH19'{ $WPF_CEth19.Fill = "$Status_Port" }
					'ETH20'{ $WPF_CEth20.Fill = "$Status_Port" }
					'ETH21'{ $WPF_CEth21.Fill = "$Status_Port" }
					'ETH22'{ $WPF_CEth22.Fill = "$Status_Port" }
					'ETH23'{ $WPF_CEth23.Fill = "$Status_Port" }
					'ETH24'{ $WPF_CEth24.Fill = "$Status_Port" }
					'Gi0/0'{ $WPF_CGI00.Fill = "$Status_Port" }
					'Gi0/1'{ $WPF_CGI01.Fill = "$Status_Port" }

					Default {}
				}
			}
			Default {}
		}
		
	}
}

function Get-ConfSwitch
{
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        [ValidateSet("HP", "Cisco")]
        $SwitchModel

    )

    Begin
    {
      $Script:observableCollection = [System.Collections.ObjectModel.ObservableCollection[Object]]::new()

    }
    Process
    {
        switch ($SwitchModel)
        {
            'HP'
            {
                $xml = [xml](Get-Content $FileHP)

                foreach ($item in $xml.HP_Ports.Port){
                $objArray = New-Object PSObject
                $objArray | Add-Member -type NoteProperty -name Interface -value "$($item.Interface)"
                $objArray | Add-Member -type NoteProperty -name Status -value "$($item.Status)"
                $objArray | Add-Member -type NoteProperty -name Message -value "$($item.Message)"
                $Script:observableCollection.Add($objArray) | Out-Null
                }
            }
            'Cisco'
            {
                $xmlCisco = [xml](Get-Content $FileCisco)

                foreach ($item in $xmlCisco.Cisco_Ports.Port){
                $objArray = New-Object PSObject
                $objArray | Add-Member -type NoteProperty -name Interface -value "$($item.Interface)"
                $objArray | Add-Member -type NoteProperty -name Status -value "$($item.Status)"
                $objArray | Add-Member -type NoteProperty -name Message -value "$($item.Message)"
                $Script:observableCollection.Add($objArray) | Out-Null
                }

            }
            Default {}
        }

    }
    End
    {
		$WPF_Datagrid.ItemsSource = $Script:observableCollection

    }
}

function Get-Backup
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [ValidateSet("HP", "Cisco")]
		$SwitchModel,
		
		[ValidateSet("yes")]
		$Backup       
    )

    Begin
    {
     switch ($SwitchModel)
     {
         'HP' 
         {
		 $root = "HP_Ports"

			if ( $PsBoundParameters.ContainsKey('Backup') ) 
			{
				$suffixe=Get-Date -Format "_dd_MM_yyyy_HHmm"
				$filename = "hp"+"$suffixe"+".xml"
			}
			else
			{
				$filename = "hp.xml"

			}
		 
		}
         'Cisco' 
         {
          $root = "Cisco_Ports"
			if ( $PsBoundParameters.ContainsKey('Backup') ) 
			{
				$suffixe=Get-Date -Format "_dd_MM_yyyy_HHmm"
				$filename = "cisco"+"$suffixe"+".xml"
			}
			else
			{
				$filename = "cisco.xml"

			}
         }
         Default {}
     }
    }
    Process
    {
        $xmlsettings = New-Object System.Xml.XmlWriterSettings
        $xmlsettings.Indent = $true
		$xmlsettings.IndentChars = "    "
		if ( $PsBoundParameters.ContainsKey('Backup') ) 
		{
			$XmlWriter = [System.XML.XmlWriter]::Create("$Global:pathPanel\Backup\$filename", $xmlsettings)
		}
		else
		{
			$XmlWriter = [System.XML.XmlWriter]::Create("$Global:pathPanel\Current\$filename", $xmlsettings)
		}

        $xmlWriter.WriteStartDocument()

        for ($i = 0; $i -lt $Script:observableCollection.count; $i++)
        { 
            if ($i -eq 0)
            {
    
            $xmlWriter.WriteStartElement("$root")
            $xmlWriter.WriteStartElement("Port") # <-- Start <Object>
            $xmlWriter.WriteElementString("Interface","$($Script:observableCollection[$i].Interface)")
            $xmlWriter.WriteElementString("Status","$($Script:observableCollection[$i].Status)")
    
                if ($null -eq $Script:observableCollection[$i].Message)
                {
                    $xmlWriter.WriteElementString("Message","")
                }
                else
                {
                    $xmlWriter.WriteElementString("Message","$($Script:observableCollection[$i].Message)")
                }

            $xmlWriter.WriteEndElement() # <-- End <Object>
            
            }
            else
            {
                $xmlWriter.WriteStartElement("Port") # <-- Start <Object>
                $xmlWriter.WriteElementString("Interface","$($Script:observableCollection[$i].Interface)")
                $xmlWriter.WriteElementString("Status","$($Script:observableCollection[$i].Status)")
                $xmlWriter.WriteElementString("Message","$($Script:observableCollection[$i].Message)")
                $xmlWriter.WriteEndElement() # <-- End <Object>
            }
        }


    }
    End
    {
    $xmlWriter.WriteEndElement() # <-- End <Root>
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()
    }
}

$WPF_save.add_Click({


	Get-Backup -SwitchModel $Global:SwitchModel 

})

$WPF_reload.add_Click({

	switch ($Global:SwitchModel ) {
		'Cisco' 
		{
			 $xmlCisco = [xml](Get-Content $FileCisco)

			 foreach ($item in $xmlCisco.Cisco_Ports.Port)
			 {
				New-PortActivity -TypeSwicth Cisco -Value $item.Interface -Status $item.Status
				New-Statistic -TypeSwicth Cisco -Value $item.Interface -Message $item.Message
			 }
			 
		}
		'HP' 
		{	
			$xmlHP = [xml](Get-Content $FileHP)
			foreach ($item in $xmlHP.HP_Ports.Port)
			{
				New-PortActivity -TypeSwicth HP -Value $item.Interface -Status $item.Status
				New-Statistic -TypeSwicth HP -Value $item.Interface -Message $item.Message
			}

		}
		Default {}
	}	
	

})

$WPF_Close.add_Click({

	# Update and refresh the content of the datagrid 
	
	$index = $observableCollection.IndexOf($resultObj)

	switch ($WPF_dialgPortStatus.SelectedIndex) {
		'1'{  $script:observableCollection[$index].Status = 'ON' }
		'0'{  $script:observableCollection[$index].Status = 'OFF'}
		'2'{  $script:observableCollection[$index].Status = 'ACC'}
		'3'{  $script:observableCollection[$index].Status = 'TRK'}
		'4'{  $script:observableCollection[$index].Status = 'AGG'}
		Default {}
	}

    $script:observableCollection[$index].Message         = $WPF_dialgMessage.Text
    $WPF_Datagrid.Items.Refresh()

    # Close the Custom Dialog
    $CustomDialog.RequestCloseAsync()

})

$WPF_backup.add_Click({


	Get-Backup -SwitchModel $Global:SwitchModel -Backup yes

})

$WPF_load.add_Click{(


	Get-ConfSwitch -SwitchModel $WPF_SwitchModel.SelectedValue 
 

)}

foreach ($item in $xmlCisco.Cisco_Ports.Port)
{
   New-PortActivity -TypeSwicth Cisco -Value $item.Interface -Status $item.Status
   New-Statistic -TypeSwicth Cisco -Value $item.Interface -Message $item.Message
}

foreach ($item in $xmlHP.HP_Ports.Port)
{

   New-PortActivity -TypeSwicth HP -Value $item.Interface -Status $item.Status
   New-Statistic -TypeSwicth HP -Value $item.Interface -Message $item.Message
}


$WPF_Exit.add_Click({


	Break

})

#Make PowerShell Disappear
$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)
 
# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

$WPF_SwitchModel.add_SelectionChanged{

	$Global:SwitchModel =   $WPF_SwitchModel.SelectedValue
	
	switch ($Global:SwitchModel ) {
		'Cisco' 
		{ 
			$WPF_logoC.Visibility = "Visible"  
			$WPF_logoH.Visibility = "Collapsed"
		}
		'HP'
		{
			$WPF_logoC.Visibility = "Collapsed"  
			$WPF_logoH.Visibility = "Visible"
		}
		Default {}
	}
	

}
$Global:SwitchModel = $WPF_SwitchModel.SelectedValue

$Form.ShowDialog() | Out-Null
