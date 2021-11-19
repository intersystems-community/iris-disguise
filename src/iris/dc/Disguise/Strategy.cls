/// iris Disguise anonymization strategies
Class dc.Disguise.Strategy Extends Core
{

/// Destruction
/// Sometimes the fastest and the best approach to anonymize a data is to replace all the values with the word CONFIDENTIAL.
ClassMethod Destruction(classname As %String, propName As %String, mask As %String = "CONFIDENTIAL") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ..GetAllData(classname, .results))
    $$$THROWONERROR(sc, ..AbstractDestruction(classname, propName, mask, .results))
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

/// Partial Masking
/// leaves out some part of the data.
ClassMethod PartialMasking(classname As %String, propName As %String, prefixLength As %Integer = 1, suffixLength As %Integer = 1, mask As %String = "X") As %Status
{
  Set sc = $$$OK
  Try {
    $$$THROWONERROR(sc, ..GetAllData(classname, .results))
    //TStart
    While (results.%Next()) {
      Set obj = $Classmethod(classname, "%OpenId", results.ID)
      If ('$IsObject(obj)) {
        Continue
      }
      Set $Property(obj, propName) = ..Obfuscating($Property(obj, propName), prefixLength, suffixLength, mask)
      $$$THROWONERROR(sc, $Method(obj,"%Save"))
    }
  } Catch ex {
    Set sc=ex.AsStatus()
  }
  Return sc
}

}