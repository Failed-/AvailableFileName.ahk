; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; %%%           _           _    _____      _            _      %%%
; %%%          | |         | |  / ____|    | |          | |     %%%
; %%%          | |_   _ ___| |_| (___   ___| |__   _ __ | |     %%%
; %%%      _   | | | | / __| __|\___ \ / _ \ '_ \ | '_ \| |     %%%
; %%%     | |__| | |_| \__ \ |_ ____) |  __/ |_) || | | | |     %%%
; %%%      \____/ \__,_|___/\__|_____/ \___|_.__(_)_| |_|_|     %%%
; %%%                                                           %%%
; %%%            Coded by Failed for JustSeb.nl                 %%%
; %%%            Released under AGPL-3.0 license                %%%
; %%%      When using the file, leave copyright in tact!        %%%
; %%%                                                           %%%
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


GetAvailableFileName( MyGivenFileName, MyGivenPath = "", FirstID = 1 )
{
  ;check if MyGivenPath exist or add a backslash "\" in case that is necessary
  If MyGivenPath is not space
    {
      StringRight, LastChar, MyGivenPath, 1
      If ( LastChar <> "\" )
        MyGivenPath = %MyGivenPath%\
      If ( InStr(FileExist(MyGivenPath), "D") = 0 )
        {
          ErrorLevel = The given path >%MyGivenPath%< doesn't exist.
          Return 0
        }
    }

  ;check if FirstID is reasonable
  If ( FirstID < 0 Or Mod(FirstID, 1) <> 0 )
    {
      ErrorLevel =
        (LTrim
           The FirstID >%FirstID%< is smaller then zero or not an integer.
           It has to be a positive integer.
        )
      Return 0
    }

  ;split MyGivenFileName with #
  StringSplit, NameArray, MyGivenFileName, #
 
  ;if MyGivenFileName doesn't contain # ...
  If NameArray0 < 2
    {
      ;check if MyGivenFileName exists
      If FileExist(MyGivenPath . MyGivenFileName)
        {
          ErrorLevel =
            (LTrim
              The given file >%MyGivenFileName%< does exist
              in path >%MyGivenPath%<.
              (if path is empty, it's the path of the script/exe)
            )
          Return 0
        }
      Else
          Return MyGivenPath . MyGivenFileName
    }

  ;check if FirstID isn't too large
  If ( StrLen(FirstID) > NameArray0 - 1 )
    {
      ErrorLevel =
        (LTrim
           The FirstID >%FirstID%< is too long
           for the filename >%MyGivenFileName%<.
        )
      Return 0
    }
 
  ;Search from FirstID ...
  Loop
    {
      Number := A_Index + FirstID - 1
             
      ;until number is too long ...
      If ( StrLen(Number) > NameArray0 - 1 )
        {
          ErrorLevel =
            (LTrim
              All files exist for >%MyGivenFileName%<
              with all # between %FirstID% and %Number%.
            )
          Return 0
        }

      ;otherwise fill number with leading zeros
      Loop, % NameArray0 - 1 - StrLen(Number) ;%
          Number = 0%Number%
     
      ;split number in an array
      StringSplit, NumberArray, Number
     
      ;mix and concatenate the names array with the numbers array
      FileName =
      Loop, %NameArray0%
          FileName := FileName . NameArray%A_Index% . NumberArray%A_Index%
     
      ;check if MyGivenFileName doesn't exist
      If not FileExist(MyGivenPath . FileName)
          Return MyGivenPath . FileName
     }
}

GetAvailableFileName_fast( MyGivenFileName, MyGivenPath = "", FirstID = 1 )
{
  StringSplit, NameArray, MyGivenFileName, #
  Loop
    {
      Number := A_Index + FirstID - 1
      Loop, % NameArray0 - 1 - StrLen(Number) ;%
          Number = 0%Number%
      StringSplit, NumberArray, Number
      FileName =
      Loop, %NameArray0%
          FileName := FileName . NameArray%A_Index% . NumberArray%A_Index%
      If not FileExist(MyGivenPath . FileName)
          Return MyGivenPath . FileName
     }
}
