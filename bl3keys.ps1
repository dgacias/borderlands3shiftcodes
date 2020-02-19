Add-Type -AssemblyName System.Windows.Forms
write-host("Getting keys...")

$REDDITURL="https://www.reddit.com/r/borderlands3/search.json?q=flair_name%3A%22[SHiFT%20Code]%20%3Ashift%3A%22&restrict_sr=1&t=week&sort=new"
$RESPONSE = Invoke-RestMethod -Uri $REDDITURL
$LINKS=$RESPONSE.data.children.data.permalink

$HASHSET = new-object System.Collections.Generic.HashSet[string]

foreach ($URL in $LINKS) {
    $FULLURL='https://www.reddit.com' + $URL + '.json'
    $RESPONSE= Invoke-RestMethod -Uri $FULLURL
    $COMMENTS=$RESPONSE.data.children.data.body

    foreach ($POST in $COMMENTS) {
        if ($POST -match '^.{5}-.{5}-.{5}-.{5}-.{5}$') {
            $WEEKKEYS = $HASHSET.Add($POST)
        }
    }
}

$KEYS = new-object system.collections.generic.List[string] $HASHSET;
$KEYS.Sort();

$Form=New-Object system.Windows.Forms.Form
$Form.ClientSize='600,360'
$Form.text="BL3 last week reddit key scrapper"
$Form.TopMost=$true

#Copy Key button link
$Button1=New-Object system.Windows.Forms.Button
$Button1.text="Copy Key"
$Button1.width=180
$Button1.height=30
$Button1.location=New-Object System.Drawing.Point(400,20)
$Button1.Font='Microsoft Sans Serif,10'
$Button1.add_Click({Write-Output $keylist.SelectedItem | Set-Clipboard})
$Form.Controls.Add($Button1)

#Redeem button link
$Button1=New-Object system.Windows.Forms.Button
$Button1.text="Redeem online"
$Button1.width=180
$Button1.height=30
$Button1.location=New-Object System.Drawing.Point(400,80)
$Button1.Font='Microsoft Sans Serif,10'
$Button1.add_Click({[system.Diagnostics.Process]::start("https://shift.gearboxsoftware.com/rewards")})
$Form.Controls.Add($Button1)

#Key list
$keylist=New-Object system.Windows.Forms.ListBox
$keylist.text="Key List"
$keylist.width=300
$keylist.height=300
$keylist.location=New-Object System.Drawing.Point(20,20)
$Form.controls.Add($keylist)


foreach($KEY in $KEYS) {
    $keylist.Items.Add($KEY.ToUpper())
}

$Form.ShowDialog()