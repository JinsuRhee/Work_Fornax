;;-----
;; Subroutine for panel
;;-----
PRO p_vrperform_draw_rtall_pan1, data, xr, yr
        cgOplot, data.xxx.fof3d.ngroup, data.xxx.fof3d.time, psym=16, symsize=1.0, color='dodger blue'
        cgOplot, data.xxx.fof6d.ngroup, data.xxx.fof6d.time, psym=16, symsize=1.0, color='light coral'

                a       = LINFIT(ALOG10(data.xxx.fof3d.ngroup), ALOG10(data.xxx.fof3d.time))
                b       = LINFIT(ALOG10(data.xxx.fof6d.ngroup), ALOG10(data.xxx.fof6d.time))
                xx      = FINDGEN(100)/99. * 2.0 + 5.0

        cgOplot, 10^xx, 10^(a(0) + a(1)*xx), linestyle=2, thick=6, color='YGB5'
        cgOplot, 10^xx, 10^(b(0) + b(1)*xx), linestyle=2, thick=6, color='orange red'

        print, a(1), b(1)
        ;cgLegend, /center_sym, /data, colors=['white', 'white'], $
        ;        location=[1.3e6, 2e1], psyms=[16, 16], titles=['3DFOF', '6DFOF'], length=0., vspace=2., $
        ;        charsize=1.0, charthick=3.0

        !p.charsize=2.0
        cgLegend, /center_sym, /data, colors=['dodger blue', 'light coral'], $
                location=[4e5, 8e0], psyms=[16, 16], length=0., vspace=3.0, $
                titles=['3D_FOF (Pow = ' + STRING(a(1),format='(F4.2)') + ')', $
                '6D_FOF (Pow = ' + STRING(b(1),format='(F4.2)') + ')'], $
                charthick=5.0, /box
        !p.charsize=2.0

        cgAxis, xaxis=0, xstyle=1, xrange=xr, xtitle='# of FOF Particles', /xlog, /save
        cgAxis, yaxis=0, ystyle=1, yrange=yr, ytitle='Run Time [s]', $
                ytickv=[1e0, 1e1, 1e2, 1e3, 1e4], ytickn=[textoidl('10^0'), $
                textoidl('10^1'), textoidl('10^2'), textoidl('10^3'), $
                textoidl('10^4')], /ylog, /save

        xr2     = xr * 8512.4066
        cgAxis, xaxis=1, xstyle=1, xrange=xr2, /xlog, /save
        cgAxis, yaxis=1, ystyle=1, yrange=yr, /ylog, ytickv=[1e0, 1e1, 1e2, 1e3, 1e4], $
                ytickn=[' ',' ',' ', ' ', ' '], /save

        XYOuts, (!X.Window[1] - !X.Window[0]) / 2 + !X.Window[0], 0.94, /Normal, $
                textoidl('Mass [M' + sunsymbol() + ']'), alignment=0.5
END

;;-----
;; Main
;;-----
PRO p_vrperform_draw_rtall, settings, data, eps=eps

	dsize	= [800., 800.]
	width	= 0.75
	height	= width * dsize(0)/dsize(1)
	hgap	= 0.18
	vgap	= 0.12

	IF settings.P_VRPerform_eps EQ 1L THEN $
		cgPS_open, settings.root_path + '/images/' + $
		settings.P_VRPerform_draw_rtall_iname, /encapsulated

	cgDisplay, dsize(0), dsize(1)
	!p.font = -1 & !p.charsize=2.0 & !p.charthick=5.0
	;;-----
	;; Panel A - Gal ptcl num VS. Time
	;;-----
	xr	= [1e5, 1e7]
	yr	= [1e0, 5e4]
	pos	= [hgap, vgap, hgap, vgap] + [0., 0., width, height]
	cgPlot, 0, 0, /nodata, xstyle=4, ystyle=4, position=pos, xrange=xr, yrange=yr, /xlog, /ylog

	P_VRPerform_draw_rtall_pan1, data, xr, yr

	IF settings.P_VRPerform_eps EQ 1L THEN cgPS_close


END