#include "dialog_hudpanel_weapons.qh"

#include "checkbox.qh"
#include "textlabel.qh"
#include "textslider.qh"
#include "slider.qh"
#include "radiobutton.qh"
#include "colorpicker_string.qh"

void XonoticHUDWeaponsDialog_fill(entity me)
{
	entity e;
	string panelname = "weapons";
	float i;

	dialog_hudpanel_main_checkbox(me, panelname);

	dialog_hudpanel_main_settings(me, panelname);

	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, _("Fade out after:")));
			me.TD(me, 1, 2.6, e = makeXonoticTextSlider(strzone(strcat("hud_panel_", panelname, "_timeout"))));
				e.addValue(e, _("Never"), "0");
				for(i = 1; i <= 10; ++i)
					e.addValue(e, strzone(sprintf(_("%ds"), i)), strzone(ftos(i)));
				e.configureXonoticTextSliderValues(e);
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, _("Fade effect:")));
		setDependentStringNotEqual(e, strzone(strcat("hud_panel_", panelname, "_timeout")), "0");
			me.TD(me, 1, 2.6, e = makeXonoticTextSlider(strzone(strcat("hud_panel_", panelname, "_timeout_effect"))));
				e.addValue(e, ZCTX(_("EF^None")),  "0");
				e.addValue(e, _("Alpha"), "1");
				e.addValue(e, _("Slide"), "2");
				e.addValue(e, ZCTX(_("EF^Both")),  "3");
				e.configureXonoticTextSliderValues(e);
			setDependentStringNotEqual(e, strzone(strcat("hud_panel_", panelname, "_timeout")), "0");
	me.TR(me);
		me.TD(me, 1, 4, e = makeXonoticTextLabel(0, _("Weapon icons:")));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 3.8, e = makeXonoticCheckBox(0, "hud_panel_weapons_onlyowned", _("Show only owned weapons")));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, _("Noncurrent alpha:")));
		me.TD(me, 1, 2.6, e = makeXonoticSlider(0, 1, 0.1, "hud_panel_weapons_noncurrent_alpha"));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, _("Noncurrent scale:")));
		me.TD(me, 1, 2.6, e = makeXonoticSlider(0, 1, 0.1, "hud_panel_weapons_noncurrent_scale"));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.4, e = makeXonoticTextLabel(0, _("Show weapon ID as:")));
			me.TD(me, 1, 0.8, e = makeXonoticRadioButton(2, "hud_panel_weapons_label", "0", ZCTX(_("SHOWAS^None"))));
			me.TD(me, 1, 0.8, e = makeXonoticRadioButton(2, "hud_panel_weapons_label", "1", _("Number")));
			me.TD(me, 1, 0.8, e = makeXonoticRadioButton(2, "hud_panel_weapons_label", "2", _("Bind")));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.4, e = makeXonoticTextLabel(0, _("Weapon ID scale:")));
			setDependent(e, "hud_panel_weapons_label", 1, 2);
			me.TD(me, 1, 2.4, e = makeXonoticSlider(0.1, 1, 0.05, "hud_panel_weapons_label_scale"));
			setDependent(e, "hud_panel_weapons_label", 1, 2);
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 3.8/2, e = makeXonoticCheckBox(0, "hud_panel_weapons_accuracy", _("Show Accuracy")));
		me.TD(me, 1, 3.8/2, e = makeXonoticCheckBox(0, "hud_panel_weapons_ammo", _("Show Ammo")));
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.4, e = makeXonoticTextLabel(0, _("Ammo bar alpha:")));
			setDependent(e, "hud_panel_weapons_ammo", 1, 1);
			me.TD(me, 1, 2.4, e = makeXonoticSlider(0.1, 1, 0.1, "hud_panel_weapons_ammo_alpha"));
			setDependent(e, "hud_panel_weapons_ammo", 1, 1);
	me.TR(me);
		me.TDempty(me, 0.2);
		me.TD(me, 1, 1.2, e = makeXonoticTextLabel(0, _("Ammo bar color:")));
			setDependent(e, "hud_panel_weapons_ammo", 1, 1);
		me.TD(me, 2, 2.4, e = makeXonoticColorpickerString("hud_panel_weapons_ammo_color", "hud_panel_weapons_ammo_color"));
			setDependent(e, "hud_panel_weapons_ammo", 1, 1);
		me.TR(me);
}
