# Read Puppetfile
$puppetFile = Get-Content .\Puppetfile
$modulesDirectory = '..\modules\'
$modulesDict = @{}

foreach($line in $puppetFile){
    if($line[0] -ne '#'){
       # $line 
        if($line.Split(' ') -contains 'moduledir'){
          $line_array = $line.Split(' ')
          $modulesDirectory = $line_array[$line_array.Count-1] -replace'['',]',''
          $modulesDirectory = "..\$modulesDirectory"
        }elseif($line.Split(' ') -contains 'mod'){
          # check for comma, there are three conditions:
          # 1. It is a forge module and there is no comma, get latest
          # 2. It is a forge module and there is a comma, get that version
          # 2. It is not a foge module and there is a comma, comes from git repo
          
          $line_array = $line.Split(',')
          if($line.Contains(',')){
            if($line_array[1] -ne ''){
                $version = $line.Split(',')[1] -replace'['']','' -replace ':', ''
                $modType = 'forge'
            }else{
                $version = 'tbd'
                $modType = 'git'
            }
          }else{
             $version = 'latest'
             $modType = 'forge'
          }
          $module = $line_array[0].Split(' ')[1] -replace'['',]',''
          if($version -eq 'git repo'){
            $git_module = $module
          }
          $modInfo = $modulesDirectory, $modType, $version
          $modulesDict.Add($module, $modInfo)
        }elseif($line.Contains(':git')){
            $repo_line = $line.Split('=>')[2].trim() -replace'['',]',''
            $modInfo = $modulesDirectory, $version, $modType, $repo_line
            $modulesDict.Set_Item($module,$modInfo)
        }elseif($line.Contains(':ref') -or $line.Contains(':tag') -or $line.Contains(':branch') -or $line.Contains(':commit')){
            $ref_type = $line.Split('=>')[0].trim() -replace'['',]','' -replace ':', ''
            $ref_ref = $line.Split('=>')[2].trim() -replace'['',]',''
            $modInfo = $modulesDirectory, $version, $modType, $repo_line, $ref_type, $ref_ref
            $modulesDict.Set_Item($module,$modInfo)
        }
    } 
}

foreach($moduleName in $modulesDict.Keys){
   # $modulesDict[$moduleName]
    '---------------------------------------'
    $modulesDirectory = $modulesDict[$moduleName][0]
    $version = $modulesDict[$moduleName][2]
    if($version -eq 'git'){
      'Clone from git repo'
      $modulesDict[$moduleName]
      $repo = $modulesDict[$moduleName][3]
      $ref_type = $modulesDict[$moduleName][4]
      $ref_ref = $modulesDict[$moduleName][5]

      switch($ref_type){
        'branch' { $options = "--b $ref_ref" }
        'ref' { $options = "-b $ref_ref" }
        'tag' { $options = "--b $ref_ref --depth 1" }
        'commit' { $options = "-b $ref_ref" }
        'default' { $options = '' }
      }

      if($ref_type -eq 'branch'){
        
      }
      $myCommand = "git clone $options $repo"
      $myCommand
      '---------------------------------------'
    }else{
      $myCommand = "puppet module install $modulename --version $version --modulepath $modulesDirectory"
      $myCommand
      "Installing $moduleName"
      #if($version -eq 'latest'){
      #    puppet module install $modulename --modulepath $modulesDirectory
      #}else{
      #   puppet module install $modulename --version $version --modulepath $modulesDirectory
      #}
    
    }
}



