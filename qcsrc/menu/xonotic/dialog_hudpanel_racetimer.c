#ifdef INTERFACE
CLASS(XonoticHUDRaceTimerDialog) EXTENDS(XonoticRootDialog)
	METHOD(XonoticHUDRaceTimerDialog, fill, void(entity))
	ATTRIB(XonoticHUDRaceTimerDialog, title, string, "Race Timer Panel")
	ATTRIB(XonoticHUDRaceTimerDialog, color, vector, SKINCOLOR_DIALOG_TEAMSELECT)
	ATTRIB(XonoticHUDRaceTimerDialog, intendedWidth, float, 0.4)
	ATTRIB(XonoticHUDRaceTimerDialog, rows, float, 15)
	ATTRIB(XonoticHUDRaceTimerDialog, columns, float, 4)
	ATTRIB(XonoticHUDRaceTimerDialog, name, string, "HUDracetimer")
ENDCLASS(XonoticHUDRaceTimerDialog)
#endif

#ifdef IMPLEMENTATION
void XonoticHUDRaceTimerDialog_fill(entity me)
{
	entity e;
	string panelname = "racetimer";
	float i;

	me.TR(me);
		me.TD(me, 1, 3, e = makeXonoticCheckBox(0, "hud_panel_racetimer", "Enable panel"));
	me.TR(me);
		me.TD(me, 1, 2, e = makeXonoticTextLabel(0, "Background:"));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, "Color:"));
		me.TD(me, 2, 2.4, e = makeXonoticColorpickerString(strzone(strcat("hud_panel_", panelname, "_bg_color"))));
			setDependentStringNotEqual(e, strzone(strcat("hud_panel_", panelname, "_bg_color")), "");
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticCheckBoxString("", "1 1 1", strzone(strcat("hud_panel_", panelname, "_bg_color")), "Use default"));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, "Border size:"));
			me.TD(me, 1, 2.6, e = makeXonoticTextSlider(strzone(strcat("hud_panel_", panelname, "_bg_border"))));
				e.addValue(e, "Default", "");
				e.addValue(e, "Disable", "0");
				for(i = 1; i <= 10; ++i)
					e.addValue(e, strzone(ftos_decimals(i * 2, 0)), strzone(ftos(i * 2)));
				e.configureXonoticTextSliderValues(e);
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, "Alpha:"));
			me.TD(me, 1, 2.6, e = makeXonoticTextSlider(strzone(strcat("hud_panel_", panelname, "_bg_alpha"))));
				e.addValue(e, "Default", "");
				for(i = 1; i <= 10; ++i)
					e.addValue(e, strzone(ftos_decimals(i/10, 1)), strzone(ftos(i/10)));
				e.configureXonoticTextSliderValues(e);
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, "Team Color:"));
			me.TD(me, 1, 2.6, e = makeXonoticTextSlider(strzone(strcat("hud_panel_", panelname, "_bg_color_team"))));
				e.addValue(e, "Default", "");
				e.addValue(e, "Disable", "0");
				for(i = 1; i <= 10; ++i)
					e.addValue(e, strzone(ftos_decimals(i/10, 1)), strzone(ftos(i/10)));
				e.configureXonoticTextSliderValues(e);
	me.TR(me);
		me.TDempty(me, 0.4);
		me.TD(me, 1, 3, e = makeXonoticCheckBox(0, "hud_configure_teamcolorforced", "Test the team color in HUD configure mode"));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, "Padding:"));
			me.TD(me, 1, 2.6, e = makeXonoticTextSlider(strzone(strcat("hud_panel_", panelname, "_bg_padding"))));
				e.addValue(e, "Default", "");
				for(i = 0; i <= 10; ++i)
					e.addValue(e, strzone(ftos_decimals(i - 5, 0)), strzone(ftos(i - 5)));
				e.configureXonoticTextSliderValues(e);
}
#endif
