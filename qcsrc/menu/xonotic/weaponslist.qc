#include "weaponslist.qh"

#include <common/weapons/_all.qh>

.bool disabled;

entity makeXonoticWeaponsList()
{
	entity me;
	me = NEW(XonoticWeaponsList);
	me.configureXonoticWeaponsList(me);
	return me;
}
void XonoticWeaponsList_configureXonoticWeaponsList(entity me)
{
	me.configureXonoticListBox(me);
}
void XonoticWeaponsList_draw(entity me)
{
	// read in cvar?
	string s, t;
	s = W_NumberWeaponOrder(cvar_string("cl_weaponpriority"));
	t = W_FixWeaponOrder(s, 1);
	if(t != s)
		cvar_set("cl_weaponpriority", W_NameWeaponOrder(t));
	me.nItems = tokenize_console(t);
	SUPER(XonoticWeaponsList).draw(me);
}
void WeaponsList_MoveUp_Click(entity box, entity me)
{
	if(me.selectedItem > 0)
	{
		cvar_set("cl_weaponpriority", swapInPriorityList(cvar_string("cl_weaponpriority"), me.selectedItem - 1, me.selectedItem));
		me.setSelected(me, me.selectedItem - 1);
	}
}
void WeaponsList_MoveDown_Click(entity box, entity me)
{
	if(me.selectedItem < me.nItems - 1)
	{
		cvar_set("cl_weaponpriority", swapInPriorityList(cvar_string("cl_weaponpriority"), me.selectedItem, me.selectedItem + 1));
		me.setSelected(me, me.selectedItem + 1);
	}
}
void XonoticWeaponsList_resizeNotify(entity me, vector relOrigin, vector relSize, vector absOrigin, vector absSize)
{
	SUPER(XonoticWeaponsList).resizeNotify(me, relOrigin, relSize, absOrigin, absSize);

	me.realFontSize_y = me.fontSize / (absSize.y * me.itemHeight);
	me.realFontSize_x = me.fontSize / (absSize.x * (1 - me.controlWidth));
	me.realUpperMargin = 0.5 * (1 - me.realFontSize.y);
}
float XonoticWeaponsList_mouseDrag(entity me, vector pos)
{
	int i = me.selectedItem;
	float f = SUPER(XonoticWeaponsList).mouseDrag(me, pos);

	if(me.pressed != 1) // don't change priority if the person is just scrolling
	{
		if(me.selectedItem != i)
		{
			if(me.applyButton)
				me.applyButton.disabled = false;
			cvar_set("cl_weaponpriority", swapInPriorityList(cvar_string("cl_weaponpriority"), me.selectedItem, i));
		}
	}

	return f;
}
string XonoticWeaponsList_toString(entity me)
{
	float n, i;
	string s;
	entity e;
	n = tokenize_console(W_NumberWeaponOrder(cvar_string("cl_weaponpriority")));
	s = "";
	for(i = 0; i < n; ++i)
	{
		e = REGISTRY_GET(Weapons, stof(argv(i)));
		s = strcat(s, e.m_name, ", ");
	}
	return substring(s, 0, strlen(s) - 2);
}
void XonoticWeaponsList_drawListBoxItem(entity me, int i, vector absSize, bool isSelected, bool isFocused)
{
	entity e;
	if(isSelected)
		draw_Fill('0 0 0', '1 1 0', SKINCOLOR_LISTBOX_SELECTED, SKINALPHA_LISTBOX_SELECTED);
	else if(isFocused)
	{
		me.focusedItemAlpha = getFadedAlpha(me.focusedItemAlpha, SKINALPHA_LISTBOX_FOCUSED, SKINFADEALPHA_LISTBOX_FOCUSED);
		draw_Fill('0 0 0', '1 1 0', SKINCOLOR_LISTBOX_FOCUSED, me.focusedItemAlpha);
	}
	e = REGISTRY_GET(Weapons, stof(argv(i)));
	string msg = e.m_name;
	if(e.spawnflags & WEP_FLAG_MUTATORBLOCKED)
		msg = strcat(msg, "*");

	vector save_fontscale = draw_fontscale;
	float f = draw_CondensedFontFactor(msg, false, me.realFontSize, 1);
	draw_fontscale.x *= f;
	vector fs = me.realFontSize;
	fs.x *= f;
	draw_Text(me.realUpperMargin * eY, msg, fs, SKINCOLOR_TEXT, SKINALPHA_TEXT, 0);
	draw_fontscale = save_fontscale;
}

float XonoticWeaponsList_keyDown(entity me, float scan, float ascii, float shift)
{
	if(ascii == 43) // +
	{
		WeaponsList_MoveUp_Click(NULL, me);
		return 1;
	}
	else if(ascii == 45) // -
	{
		WeaponsList_MoveDown_Click(NULL, me);
		return 1;
	}
	else if(SUPER(XonoticWeaponsList).keyDown(me, scan, ascii, shift))
		return 1;
	return 0;
}
