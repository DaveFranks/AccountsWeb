<#
.Synopsis
   Generate a <machineKey> element that can be copied + pasted into a Web.config file.
.DESCRIPTION
      Generate a <machineKey> element that can be copied + pasted into a Web.config file.
      As soon as you have a <machineKey> element, you can put it in the Web.config file. The <machineKey> element is only valid in the Web.config 
      file at the root of your application and is not valid at the subfolder level. To enable for all websites on a server, this element should be
      placed placed into the Root web.config file.

.EXAMPLE
      For ASP.NET 4.0 applications, you can just call Generate-MachineKey without parameters to generate a <machineKey> element as follows:

      PS> Generate-MachineKey
      <machineKey decryption="AES" decryptionKey="..." validation="HMACSHA256" validationKey="..." />

.EXAMPLE
      ASP.NET 2.0 and 3.5 applications do not support HMACSHA256. Instead, you can specify SHA1 to generate a compatible <machineKey> element as follows:

      PS> Generate-MachineKey -validation sha1
      <machineKey decryption="AES" decryptionKey="..." validation="SHA1" validationKey="..." />

.PARAMETER decryptionAlgorithm
      The decryption Algorithm can be one of the following: ("AES", "DES", "3DES")

.PARAMETER validationAlgorithm
      The validation Algorithm can be one of the following: ("MD5", "SHA1", "HMACSHA256", "HMACSHA384", "HMACSHA512")
#>
function Generate-MachineKey {
  [CmdletBinding()]
  param (
    [ValidateSet("AES", "DES", "3DES")]
    [string]$decryptionAlgorithm = 'AES',
    [ValidateSet("MD5", "SHA1", "HMACSHA256", "HMACSHA384", "HMACSHA512")]
    [string]$validationAlgorithm = 'HMACSHA256'
  )
  process {
    function BinaryToHex {
        [CmdLetBinding()]
        param($bytes)
        process {
            $builder = new-object System.Text.StringBuilder
            foreach ($b in $bytes) {
              $builder = $builder.AppendFormat([System.Globalization.CultureInfo]::InvariantCulture, "{0:X2}", $b)
            }
            $builder
        }
    }
    switch ($decryptionAlgorithm) {
      "AES" { $decryptionObject = new-object System.Security.Cryptography.AesCryptoServiceProvider }
      "DES" { $decryptionObject = new-object System.Security.Cryptography.DESCryptoServiceProvider }
      "3DES" { $decryptionObject = new-object System.Security.Cryptography.TripleDESCryptoServiceProvider }
    }
    $decryptionObject.GenerateKey()
    $decryptionKey = BinaryToHex($decryptionObject.Key)
    $decryptionObject.Dispose()
    switch ($validationAlgorithm) {
      "MD5" { $validationObject = new-object System.Security.Cryptography.HMACMD5 }
      "SHA1" { $validationObject = new-object System.Security.Cryptography.HMACSHA1 }
      "HMACSHA256" { $validationObject = new-object System.Security.Cryptography.HMACSHA256 }
      "HMACSHA385" { $validationObject = new-object System.Security.Cryptography.HMACSHA384 }
      "HMACSHA512" { $validationObject = new-object System.Security.Cryptography.HMACSHA512 }
    }
    $validationKey = BinaryToHex($validationObject.Key)
    $validationObject.Dispose()
    [string]::Format([System.Globalization.CultureInfo]::InvariantCulture,
      "<machineKey decryption=`"{0}`" decryptionKey=`"{1}`" validation=`"{2}`" validationKey=`"{3}`" />",
      $decryptionAlgorithm.ToUpperInvariant(), $decryptionKey,
      $validationAlgorithm.ToUpperInvariant(), $validationKey)
  }
}