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

;**********
;draw figures
;**********
  do r=0,2,1
    do m=0,10,1

      f1      = addfile(indir_prefix+rcp(r)+"/"+modelname(m)+"/wsdiETCCDI_"+modelname(m)+"_"+rcp(r)+"_2041-2060.nc","r")
      f3      = addfile(indir_prefix+rcp(r)+"/"+modelname(m)+"/wsdiETCCDI_"+modelname(m)+"_"+rcp(r)+"_2061-2080.nc","r")
      f2      = addfile("/home/huitang/Documents/data/Indre/climate_extremes/10min/MCD12C1.A2001001.051.2014274170618_10x10min_mask.nc","r")

;----read era data

      var1          = f1->wsdiETCCDI(0,:,:)
      printVarSummary(var1)
      var2          = f3->wsdiETCCDI(0,:,:)
      printVarSummary(var2)
 
      lon           = f2->lon(:)
      lat           = f2->lat(:)
      printVarSummary(lon)
      printVarSummary(lat)
      nlon          = dimsizes(lon)
      nlat          = dimsizes(lat)

      Opt                = True
      Opt@PrintTimings   = True
      Opt@Debug          = True
      var1_regrid = ESMF_regrid_with_weights(var1,"/home/huitang/Documents/data/mapping_data/map_"+modelname(m)+"_nomask_to_1080x2160_mask_aave_da_c200319.nc",Opt)
      var2_regrid = ESMF_regrid_with_weights(var2,"/home/huitang/Documents/data/mapping_data/map_"+modelname(m)+"_nomask_to_1080x2160_mask_aave_da_c200319.nc",Opt)

      printVarSummary(var1_regrid)

      system("rm -f "+indir_prefix+rcp(r)+"/wsdiETCCDI_"+modelname(m)+"_"+rcp(r)+"_2041-2060_10min.nc")
      fsw  = addfile(indir_prefix+rcp(r)+"/wsdiETCCDI_"+modelname(m)+"_"+rcp(r)+"_2041-2060_10min.nc","c")      

      setfileoption(fsw,"DefineMode",True)

      fAtt               = True            ; assign file attributes
      fAtt@case_title    = "ETCCDI indices:CLIMEX"  
      fAtt@conventions   = "CF-1.0" 
      fAtt@title         = "ETCCDI indices:CLIMEX"  
      fAtt@history       = "ETCCDI indices:CLIMEX"
      fAtt@creation_date = systemfunc ("date")        
      fileattdef( fsw, fAtt )            ; copy file attributes  

      dimNames = (/"lon","lat"/)  
      dimSizes = (/ nlon, nlat/) 
      dimUnlim = (/ False, False/)   
      filedimdef(fsw,dimNames,dimSizes,dimUnlim)

      filevardef(fsw, "lon" ,typeof(lon),getvardims(lon))                                              
      filevardef(fsw, "lat" ,typeof(lat)  ,getvardims(lat))          
      filevardef(fsw, "wsdiETCCDI",typeof(var1_regrid),getvardims(var1_regrid))
                    
      filevarattdef(fsw,"lon",lon)                    
      filevarattdef(fsw,"lat",lat)                                     
      filevarattdef(fsw,"wsdiETCCDI",var1_regrid)

      setfileoption(fsw,"DefineMode",False)
      fsw->lon        = (/lon/)
      fsw->lat        = (/lat/)
      fsw->wsdiETCCDI= (/var1_regrid(:,:)/)    

      system("rm -f "+indir_prefix+rcp(r)+"/wsdiETCCDI_"+modelname(m)+"_"+rcp(r)+"_2061-2080_10min.nc")
      fsw  = addfile(indir_prefix+rcp(r)+"/wsdiETCCDI_"+modelname(m)+"_"+rcp(r)+"_2061-2080_10min.nc","c")      

      setfileoption(fsw,"DefineMode",True)

      fAtt               = True            ; assign file attributes
      fAtt@case_title    = "ETCCDI indices:CLIMEX"  
      fAtt@conventions   = "CF-1.0" 
      fAtt@title         = "ETCCDI indices:CLIMEX"  
      fAtt@history       = "ETCCDI indices:CLIMEX"
      fAtt@creation_date = systemfunc ("date")        
      fileattdef( fsw, fAtt )            ; copy file attributes  

      dimNames = (/"lon","lat"/)  
      dimSizes = (/ nlon, nlat/) 
      dimUnlim = (/ False, False/)   
      filedimdef(fsw,dimNames,dimSizes,dimUnlim)

      filevardef(fsw, "lon" ,typeof(lon),getvardims(lon))                                              
      filevardef(fsw, "lat" ,typeof(lat)  ,getvardims(lat))          
      filevardef(fsw, "wsdiETCCDI",typeof(var2_regrid),getvardims(var2_regrid))
                    
      filevarattdef(fsw,"lon",lon)                    
      filevarattdef(fsw,"lat",lat)                                     
      filevarattdef(fsw,"wsdiETCCDI",var2_regrid)

      setfileoption(fsw,"DefineMode",False)
      fsw->lon        = (/lon/)
      fsw->lat        = (/lat/)
      fsw->wsdiETCCDI= (/var2_regrid(:,:)/)    

      delete(var1)
      delete(var2)
    end do

    
    system("cdo ensmean "+indir_prefix+rcp(r)+"/wsdiETCCDI_*_"+rcp(r)+"_2041-2060_10min.nc "+indir_prefix+rcp(r)+"/wsdiETCCDI_ens_"+rcp(r)+"_2041-2060_10min.nc")
    system("cdo ensmean "+indir_prefix+rcp(r)+"/wsdiETCCDI_*_"+rcp(r)+"_2061-2080_10min.nc "+indir_prefix+rcp(r)+"/wsdiETCCDI_ens_"+rcp(r)+"_2061-2080_10min.nc")

  end do


end 
