load "/usr/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "/usr/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "/usr/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/usr/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "/usr/lib/ncarg/nclscripts/csm/popRemap.ncl"
load "/usr/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

begin

  indir_prefix="/home/huitang/Documents/data/climate_extreme_indices/CMIP5/"
  
  modelname=(/"bcc-csm1-1","CCSM4","CNRM-CM5","HadGEM2-ES","IPSL-CM5A-LR","MIROC-ESM-CHEM","MIROC-ESM","MIROC5","MPI-ESM-LR","MRI-CGCM3","NorESM1-M"/)
  rcp=(/"rcp26","rcp45","rcp85"/)
  varname=(/"cddETCCDI","csdiETCCDI","cwdETCCDI","dtrETCCDI","fdETCCDI","gslETCCDI","idETCCDI","prcptotETCCDI","r1mmETCCDI", "r10mmETCCDI","r20mmETCCDI","r95pETCCDI","r99pETCCDI","rx1dayETCCDI","rx5dayETCCDI","sdiiETCCDI","suETCCDI","tn10pETCCDI","tn90pETCCDI", "tnnETCCDI","tnxETCCDI","trETCCDI","tx10pETCCDI","tx90pETCCDI","txnETCCDI","txxETCCDI","wsdiETCCDI"/)

;**********
;draw figures
;**********
  do r=0,0,1
    do m=0,10,1
      do v=0,0,1

        f1      = addfile(indir_prefix+rcp(r)+"/"+modelname(m)+"/"+varname(v)+"_"+modelname(m)+"_"+rcp(r)+"_2041-2060.nc","r")
        lat     = f1->lat(:)
        lon     = f1->lon(:)

        printVarSummary(lat)
        printVarSummary(lon)

        Opt1                = True
        Opt1@ForceOverwrite = True
       ;Opt1@GridMask       = where(.not.ismissing(var),1,0)
       ;Opt1@GridMask         = (/1/)
       ;Opt1@GridCornerLat  = (/yfloor,yfloor,yceil,yceil/)
       ;Opt1@GridCornerLon  = (/xfloor,xceil,xceil,xfloor/)

       ;rectilinear_to_SCRIP("/home/huitang/Documents/data/SCRIPgrid_data/SCRIPgrid_"+modelname(m)+"_nomask.nc",lat,lon,Opt1)
      end do
      delete(lat)
      delete(lon)      
    end do
  end do

  f2    = addfile("/home/huitang/Documents/data/WorldClim/WorldClim1.4_cmip5/rcp26/ens26bi501.nc","r")
  lat     = f2->lat(:)
  lon     = f2->lon(:)
  printVarSummary(lat)
  printVarSummary(lon)
  Opt1                = True
  Opt1@ForceOverwrite = True
  rectilinear_to_SCRIP("/home/huitang/Documents/data/SCRIPgrid_data/SCRIPgrid_worldclim1.4_nomask.nc",lat,lon,Opt1)
    
end 
