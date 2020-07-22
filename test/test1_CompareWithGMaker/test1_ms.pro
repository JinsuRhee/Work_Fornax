Pro test1_ms, settings, vr, gm


	cgDisplay, 1200, 600
	!p.font	= -1 & !p.charsize=1.5
	pos	= [0.1, 0.2, 0.45, 0.9]
	xr	= [1e6, 1e11]
	yr	= [1e-3, 1e2]

	xx	= findgen(100)/99.*5. + 6.
	xx	= 10^xx
	yy	= xx / (1e8)

	;;-----
	cgPlot, 0, 0, /xlog, /ylog, /nodata, xrange=xr, yrange=yr, $
		xtitle='Galaxy Mass [M_sun]', ytitle='SFR [M_sun/yr]', $
		position=pos

	cgOplot, vr.mass, vr.sfr, psym=16, symsize=0.5

	cut	= where(vr.mass gt 1e9 and vr.sfr gt 0.)
	aa	= linfit(alog10(vr.mass(cut)), alog10(vr.sfr(cut)))

	print, aa
	cgOplot, vr.mass(cut), vr.sfr(cut), psym=16, symsize=0.5, color='blue'
	cgOplot, xx, 10^(alog10(xx) * aa(1) + aa(0)), linestyle=0, thick=2, color='blue'


	cgOplot, xx, yy, linestyle=2, thick=4, color='red'



	pos	= pos + [0.5, 0., 0.5, 0.]
	;;-----
	cgPlot, 0, 0, /xlog, /ylog, /noerase, /nodata, $
		xrange=xr, yrange=yr, $
		xtitle='Galaxy Mass [M_sun]', ytitle='SFR [M_sun/yr]', $
		position=pos

	cgOplot, gm.mass, gm.sfr2, psym=16, symsize=0.5

	cut	= where(gm.mass gt 1e9 and gm.sfr2 gt 0.)
	aa	= linfit(alog10(gm.mass(cut)), alog10(gm.sfr2(cut)))

	print, aa
	cgOplot, gm.mass(cut), gm.sfr2(cut), psym=16, symsize=0.5, color='blue'
	cgOplot, xx, 10^(alog10(xx) * aa(1) + aa(0)), linestyle=0, thick=2, color='blue'

	cgOplot, xx, yy, linestyle=2, thick=4, color='red'

	stop
End








End
