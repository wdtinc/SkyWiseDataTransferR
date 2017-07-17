# SkyWiseDataTransferR
API for interacting with the SkyWise Data Transfer API

# Usage

```r
> Authorize('yourappid', 'yourappkey')
> products <- GetProducts()
> products[[14]]
$datasets
[1] "/products/skywise-europe-surface-analysis/datasets"

$name
[1] "skywise-europe-surface-analysis"

$format
[1] "NetCDF"

> name <- products[[14]]$name

> files <- DataTransfer(name, directory = '.')
trying URL 'https://transfer.wdtinc.com/...
Content type 'binary/octet-streamde' length 89059615 bytes (84.9 MB)
==================================================
downloaded 84.9 MB
```
