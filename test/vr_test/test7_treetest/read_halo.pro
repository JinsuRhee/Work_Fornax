function read_halo, $
	fileDM=fileDM, $
	fileinfo=fileinfo, $
	mmin=mmin, x0=x0, y0=y0, z0=z0, zoom=zoom, $
	verbose=verbose

	if keyword_set(dir)then fileDM = dir + '/' + fileDM
	if not keyword_set(mmin)then mmin=1d5
	if not keyword_set(zoom)then zoom=1d0
	if not keyword_set(x0)then x0=0.5d0
	if not keyword_set(y0)then y0=0.5d0
	if not keyword_set(z0)then z0=0.5d0


	nbodies=0L & nb_of_halos=0L & nb_of_subhalos=0L & nb_of_parts=0L
	my_number=0LL & my_timestep=0L & nbsub=0L
	hosthalo=0LL & hostsub=0LL & level=0L & nextsub=0LL

	rd_info,info,file=fileinfo

	xmin=(x0-0.5/zoom-0.5d0)*(info.unit_l/3.08d24)
	xmax=(x0+0.5/zoom-0.5d0)*(info.unit_l/3.08d24)
	ymin=(y0-0.5/zoom-0.5d0)*(info.unit_l/3.08d24)
	ymax=(y0+0.5/zoom-0.5d0)*(info.unit_l/3.08d24)
	zmin=(z0-0.5/zoom-0.5d0)*(info.unit_l/3.08d24)
	zmax=(z0+0.5/zoom-0.5d0)*(info.unit_l/3.08d24)
	;x00=(x0-0.5d0)*(info.unit_l/3.08d24)
	;y00=(y0-0.5d0)*(info.unit_l/3.08d24)
	;z00=(z0-0.5d0)*(info.unit_l/3.08d24)
	;if keyword_set(verbose) then print,xmin,xmax,ymin,ymax,zmin,zmax
	;if keyword_set(verbose) then print,x00,y00,z00

	mH=1.66d-24 & kB=1.38d-16
	lbox=info.unit_l/3.08d24/zoom

	massp = float(0.0) & aexp = float(0.0) & omega_t = float(0.0) & age_univ = float(0.0)
	nb_of_halos = 0L & nb_of_subhalos = 0L

	openr,1,fileDM,/f77_unformatted
	readu,1,nbodies
	readu,1,massp
	readu,1,aexp
	readu,1,omega_t
	readu,1,age_univ
	readu,1,nb_of_halos,nb_of_subhalos
	if keyword_set(verbose) then begin
		print,'nbodies =',nbodies
		print,'massp   =',massp
		print,'aexp    =',aexp
		print,'omega_t =',omega_t
		print,'age_univ=',age_univ
		print,'Nombre de halos     =',nb_of_halos
		print,'Nombre de sous-halos=',nb_of_subhalos
	endif
	nmax=nb_of_halos+nb_of_subhalos

	output	= {numpart:lonarr(nmax), id:lonarr(nmax), $
			xx:dblarr(nmax), yy:dblarr(nmax), zz:dblarr(nmax), $
			vx:dblarr(nmax), vy:dblarr(nmax), vz:dblarr(nmax), $
			rvir:dblarr(nmax), mvir:dblarr(nmax)}

	nb_of_parts = 1L & my_number = 0L & my_timestep = 0L & level = 0L
	hosthalo = 0L & hostsub = 0L & hostsub = 0L & nbsub = 0L & nextsub = 0L
	m = float(0.0) & px = float(0.0) & py = float(0.0) & pz = float(0.0)
	vx = float(0.0) & vy = float(0.0) & vz = float(0.0)
	Lx = float(0.d) & Ly = float(0.d) & Lz = float(0.d)
	r = float(0.0) & sha = float(0.0) & shb = float(0.0) & shc = float(0.0)

	ek = float(0.0) & ep = float(0.0) & et = float(0.0) & spin = float(0.0)
	sigma = float(0.0) & sigma_bulge = float(0.0) & m_bulge = float(0.0)
	rvir = float(0.0) & mvir = float(0.0) & tvir = float(0.0) & cvel = float(0.0)
	rho_0 = float(0.0) & r_c = float(0.0)
	nbin = 100L & rr = fltarr(nbin) & rho = fltarr(nbin)
	for i=0L,nmax-1 do begin
	    readu,1,nb_of_parts
	    members=lonarr(nb_of_parts)
	    readu,1,members
	    ; Read properties of each halo
	    readu,1,my_number
	    readu,1,my_timestep
	    readu,1,level,hosthalo,hostsub,nbsub,nextsub
	    readu,1,m
	    readu,1,px,py,pz
	    readu,1,vx,vy,vz
	    readu,1,Lx,Ly,Lz
	    readu,1,r,sha,shb,shc
	    readu,1,ek,ep,et
	    readu,1,spin
	    readu,1, sigma, sigma_bulge, m_bulge
	    readu,1,rvir,mvir,tvir,cvel
	    readu,1,rho_0,r_c
	    readu,1,nbin
	    readu,1,rr
	    readu,1,rho

	output.numpart(i)	= nb_of_parts
	output.id(i)		= my_number
	output.xx(i)		= px
	output.yy(i)		= py
	output.zz(i)		= pz
	output.vx(i)		= vx
	output.vy(i)		= vy
	output.vz(i)		= vz
	output.mvir(i)		= mvir*1d11
	output.rvir(i)		= rvir

	    if (px lt xmax and py lt ymax and pz lt zmax and px gt xmin and py gt ymin and pz gt zmin) then begin
		xc=px
		yc=py
		rc=rvir
		;if keyword_set(radius)then rc=rvir
		;if keyword_set(mass)then rc=(alog10(double(m*1d11   )/1d9)+1)*0.005d0*lbox
		;if keyword_set(mvirial)then rc=(alog10(double(mvir*1d11)/1d9)+1)*0.005d0*lbox
		;if(m*1d11 gt mmin)then begin
		;    x = xc - x00 + rc * COS(points )
		;    y = yc - y00 + rc * SIN(points )
		;endif
	    endif

	endfor
	close,1

	;; Unit conversion
	output.xx	= (output.xx + 0.5*(info.unit_l/3.086d24))*1e3
	output.yy	= (output.yy + 0.5*(info.unit_l/3.086d24))*1e3
	output.zz	= (output.zz + 0.5*(info.unit_l/3.086d24))*1e3
	output.rvir	= output.rvir*1e3
	return, output
end
