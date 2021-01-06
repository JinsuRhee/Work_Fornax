PRO vr_test12_draw, settings, tree, vr_compid, yz_compid, n0=n0, n1=n1, vr=vr, yz=yz, xr=xr, yr=yr, n_pix=n_pix, eps=eps, id0=id0

IF KEYWORD_SET(vr) THEN BEGIN

	traj = dblarr(n1-n0+1,2)
	mass = dblarr(n1-n0+1,2)
	xr2	= [-100., 100.]
	yr2	= xr2
	FOR i=n0, n1 DO BEGIN
		IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'test/vr_test/test12*/vr_' + $
			STRING(id0,format='(I4.4)') + '_' + $
			STRING(i - n0,format='(I3.3)') + '.eps', /encapsulated

		Dsize	= [2400., 800.]
		cgDisplay, Dsize(0), Dsize(1)
		!p.font = -1 & !p.charsize=1.5 & !p.color=255B

		;; Read Galaxies
		HGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=tree.vr.id(i))
		CGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=vr_compid(i))

		traj(i-n0,0)	= CGAL.xc(0) - HGAL.xc(0)
		traj(i-n0,1)	= CGAL.yc(0) - HGAL.yc(0)

		mass(i-n0,*)	= [HGAL.mass_tot(0), CGAL.mass_tot(0)]

		;; Raw DATA
		POS	= [0., 0., 0.33, 1.0]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4, /nodata, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, /raw, boxrange=xr(1))


		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgOplot, 0., 0., psym=16, symsize=1.2, color='blue'
		cgOplot, CGAL.xc(0) - HGAL.xc(0), CGAL.yc(0) - HGAL.yc(0), psym=16, symsize=1.2, color='red'
		cgOplot, traj(0:i-n0,0), traj(0:i-n0,1), linestyle=2, color='red'

		cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.1, $
			'a = ' + STRING(HGAL.aexp,format='(F5.3)'), /data, color='white'

		!p.charsize	= 0.5
		;; Host Galaxy
		POS	= [0.33, 0., 0.66, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, boxrange=xr2(1))

		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=1L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.56, 0.81, 0.65, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, LINDGEN(i) + n0, mass(0L:i-n0,0), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,0), psym=16, color='red', symsize=0.7

		;; Comp Galaxy
		POS	= [0.66, 0., 0.99, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		PTCL	= f_rdptcl(settings, vr_compid(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, boxrange=xr2(1))

		draw_gal, PTCL.xp, PTCL.mp, CGAL, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=3L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.9, 0.81, 0.99, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, LINDGEN(i) + n0, mass(0L:i-n0,1), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,1), psym=16, color='red', symsize=0.7

		IF KEYWORD_SET(eps) THEN cgPS_close

	ENDFOR

ENDIF

IF KEYWORD_SET(yz) THEN BEGIN
	traj = dblarr(n1-n0+1,2)
	mass = dblarr(n1-n0+1,2)
	xr2	= [-50., 50.]
	yr2	= xr2
	FOR i=n0, n1  DO BEGIN
		IF i EQ n1 -1L THEN CONTINUE
		IF i EQ 87L THEN CONTINUE
		IF i EQ 86L THEN CONTINUE
		IF KEYWORD_SET(eps) THEN cgPS_open, settings.root_path + 'test/vr_test/test12*/yz_' + $
			STRING(id0,format='(I4.4)') + '_' + $
			STRING(i - n0,format='(I3.3)') + '.eps', /encapsulated

		Dsize	= [2400., 800.]
		cgDisplay, Dsize(0), Dsize(1)
		!p.font = -1 & !p.charsize=1.5 & !p.color=255B

		;; Read DATA
		HGAL	= f_rdgal(settings, tree.vr.snaplist(i), settings.column_list, id=tree.vr.id(i))


		infoname= settings.dir_raw + 'output_' + STRING(tree.vr.snaplist(n1),format='(I5.5)') + $
			'/info_' + STRING(tree.vr.snaplist(n1),format='(I5.5)') + '.txt'
		rd_info, info, file=infoname

		;; READ HOST
		dir	= '/storage1/NewHorizon/GalaxyMaker/GAL_' + STRING(tree.vr.snaplist(i),format='(I5.5)')
		dir2	= '/storage5/NewHorizon/GalaxyMaker/GAL_' + STRING(tree.vr.snaplist(i),format='(I5.5)')
		rd_gal, dum, dir=dir, idgal=yz_compid.host(i), subdir=dir2
		YZ_HG   = {xc:dum.xg, yc:dum.yg, zc:dum.zg, $
                        lx:[dum.lxg], ly:[dum.lyg], lz:[dum.lzg], mass_tot:dum.mg}
                YZ_HP   = {xp:[[dum.xp(*,0)], [dum.xp(*,1)], [dum.xp(*,2)]], $
                        mp:dum.mp*1e11}

                YZ_HG.xc        = (YZ_HG.xc + 0.5*(info.unit_l/3.086d24))*1e3
                YZ_HG.yc        = (YZ_HG.yc + 0.5*(info.unit_l/3.086d24))*1e3
                YZ_HG.zc        = (YZ_HG.zc + 0.5*(info.unit_l/3.086d24))*1e3
                YZ_HP.xp        = (YZ_HP.xp + 0.5*(info.unit_l/3.086d24))*1e3


		;; READ SAT
		dir	= '/storage1/NewHorizon/GalaxyMaker/GAL_' + STRING(tree.vr.snaplist(i),format='(I5.5)')
		dir2	= '/storage5/NewHorizon/GalaxyMaker/GAL_' + STRING(tree.vr.snaplist(i),format='(I5.5)')
		rd_gal, dum, dir=dir, idgal=yz_compid.sate(i), subdir=dir2

                YZ_SG   = {xc:dum.xg, yc:dum.yg, zc:dum.zg, $
                        lx:[dum.lxg], ly:[dum.lyg], lz:[dum.lzg], mass_tot:dum.mg}
                YZ_SP   = {xp:[[dum.xp(*,0)], [dum.xp(*,1)], [dum.xp(*,2)]], $
                        mp:dum.mp*1e11}

                YZ_SG.xc        = (YZ_SG.xc + 0.5*(info.unit_l/3.086d24))*1e3
                YZ_SG.yc        = (YZ_SG.yc + 0.5*(info.unit_l/3.086d24))*1e3
                YZ_SG.zc        = (YZ_SG.zc + 0.5*(info.unit_l/3.086d24))*1e3
                YZ_SP.xp        = (YZ_SP.xp + 0.5*(info.unit_l/3.086d24))*1e3

		traj(i-n0,0)	= YZ_SG.xc(0) - YZ_HG.xc(0)
		traj(i-n0,1)	= YZ_SG.yc(0) - YZ_HG.yc(0)

		mass(i-n0,*)	= [YZ_HG.mass_tot(0), YZ_SG.mass_tot(0)]

		;; Raw DATA
		POS	= [0., 0., 0.33, 1.0]
		cgPlot, 0, 0, xrange=xr, yrange=yr, position=pos, xstyle=4, ystyle=4, /nodata, background='black'

		PTCL	= f_rdptcl(settings, tree.vr.id(i), /p_pos, /p_mass, num_thread=settings.num_thread, $
			n_snap=tree.vr.snaplist(i), /longint, /yzics, /raw, boxrange=xr(1))


		draw_gal, PTCL.xp, PTCL.mp, HGAL, 0L, xr=xr, yr=yr, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=0L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgOplot, 0., 0., psym=16, symsize=0.7, color='blue'
		cgOplot, YZ_SG.xc(0) - YZ_HG.xc(0), YZ_SG.yc(0) - YZ_HG.yc(0), psym=16, symsize=0.7, color='red'
		cgOplot, traj(0:i-n0,0), traj(0:i-n0,1), linestyle=2, color='red'

		cgText, xr(0) + (xr(1) - xr(0))*0.1, yr(0) + (yr(1) - yr(0))*0.1, $
			'a = ' + STRING(HGAL.aexp,format='(F5.3)'), /data, color='white'

		!p.charsize	= 0.5
		;; HOST DATA
		POS	= [0.33, 0., 0.66, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		draw_gal, YZ_HP.xp, YZ_HP.mp, YZ_HG, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=1L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.56, 0.81, 0.65, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, LINDGEN(i) + n0, mass(0L:i-n0,0), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,0), psym=16, color='red', symsize=0.7

		;; SAT DATA
		POS	= [0.66, 0., 0.99, 1.0]
		cgPlot, 0, 0, xrange=xr2, yrange=yr2, position=pos, xstyle=4, ystyle=4, /nodata, /noerase, background='black'

		draw_gal, YZ_SP.xp, YZ_SP.mp, YZ_SG, 0L, xr=xr2, yr=yr2, proj='noproj', n_pix=n_pix, $
			num_thread=settings.num_thread, maxis=[0L, 1L], ctable=3L, /logscale, $
			position=pos, kernel=1L, drange=[2.0, 10.0]

		cgPlot, 0, 0, /noerase, xrange=[n0, n1], yrange=[1e8, 5e11], /ylog, position=[0.9, 0.81, 0.99, 0.99], background='black', $
			axiscolor='white', color='white'
		cgOplot, LINDGEN(i) + n0, mass(0L:i-n0,1), linestyle=0, thick=2, color='white'
		cgOplot, i, mass(i-n0,1), psym=16, color='red', symsize=0.7

		IF KEYWORD_SET(eps) THEN cgPS_close

		;STOP
	ENDFOR

ENDIF
END