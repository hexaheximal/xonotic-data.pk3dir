#include "path_waypoint.qh"

#include <server/bot/api.qh>
#include <server/pathlib/main.qh>
#include <server/pathlib/pathlib.qh>

var float pathlib_wpp_open(entity wp, entity child, float cost);

void pathlib_wpp_close(entity wp)
{
    --pathlib_open_cnt;
    ++pathlib_closed_cnt;

    wp.pathlib_list = closedlist;

    if(wp == best_open_node)
        best_open_node = NULL;

    if(wp == goal_node)
        pathlib_foundgoal = true;
}

float pathlib_wpp_opencb(entity wp, entity child, float cost)
{

    if(child.pathlib_list == closedlist)
        return false;

	// FIXME! wp.wp##mincost is NOT distance. Make it distance or add a field for distance to be used here (for better speed)
	cost = vlen(child.origin - wp.origin);

    child.path_prev 	 = wp;
    child.pathlib_list   = openlist;
    child.pathlib_node_g = wp.pathlib_node_g + cost;
    child.pathlib_node_h = pathlib_heuristic(child.origin, goal_node.origin);
    child.pathlib_node_c = pathlib_wpp_waypointcallback(child, wp);
    child.pathlib_node_f = child.pathlib_node_g + child.pathlib_node_h + child.pathlib_node_c;


    if(child == goal_node)
        pathlib_foundgoal = true;

    ++pathlib_open_cnt;

    if(best_open_node.pathlib_node_f > child.pathlib_node_f)
        best_open_node = child;

    return true;
}

float pathlib_wpp_openncb(entity wp, entity child, float cost)
{

    if(child.pathlib_list == closedlist)
        return false;

	// FIXME! wp.wp##mincost is NOT distance. Make it distance or add a field for distance to be used here (for better speed)
	cost = vlen(child.origin - wp.origin);

    child.path_prev 	 = wp;
    child.pathlib_list   = openlist;
    child.pathlib_node_g = wp.pathlib_node_g + cost;
    child.pathlib_node_h = pathlib_heuristic(child.origin, goal_node.origin);
    child.pathlib_node_f = child.pathlib_node_g + child.pathlib_node_h;

    if(child == goal_node)
        pathlib_foundgoal = true;

    ++pathlib_open_cnt;

    if(best_open_node.pathlib_node_f > child.pathlib_node_f)
        best_open_node = child;

    return true;
}

float pathlib_wpp_expand(entity wp)
{
    if(wp.wp00) pathlib_wpp_open(wp,wp.wp00, wp.wp00mincost); else return 0;
    if(wp.wp01) pathlib_wpp_open(wp,wp.wp01, wp.wp01mincost); else return 1;
    if(wp.wp02) pathlib_wpp_open(wp,wp.wp02, wp.wp02mincost); else return 2;
    if(wp.wp03) pathlib_wpp_open(wp,wp.wp03, wp.wp03mincost); else return 3;
    if(wp.wp04) pathlib_wpp_open(wp,wp.wp04, wp.wp04mincost); else return 4;
    if(wp.wp05) pathlib_wpp_open(wp,wp.wp05, wp.wp05mincost); else return 5;
    if(wp.wp06) pathlib_wpp_open(wp,wp.wp06, wp.wp06mincost); else return 6;
    if(wp.wp07) pathlib_wpp_open(wp,wp.wp07, wp.wp07mincost); else return 7;
    if(wp.wp08) pathlib_wpp_open(wp,wp.wp08, wp.wp08mincost); else return 8;
    if(wp.wp09) pathlib_wpp_open(wp,wp.wp09, wp.wp09mincost); else return 9;
    if(wp.wp10) pathlib_wpp_open(wp,wp.wp10, wp.wp10mincost); else return 10;
    if(wp.wp11) pathlib_wpp_open(wp,wp.wp11, wp.wp11mincost); else return 11;
    if(wp.wp12) pathlib_wpp_open(wp,wp.wp12, wp.wp12mincost); else return 12;
    if(wp.wp13) pathlib_wpp_open(wp,wp.wp13, wp.wp13mincost); else return 13;
    if(wp.wp14) pathlib_wpp_open(wp,wp.wp14, wp.wp14mincost); else return 14;
    if(wp.wp15) pathlib_wpp_open(wp,wp.wp15, wp.wp15mincost); else return 15;
    if(wp.wp16) pathlib_wpp_open(wp,wp.wp16, wp.wp16mincost); else return 16;
    if(wp.wp17) pathlib_wpp_open(wp,wp.wp17, wp.wp17mincost); else return 17;
    if(wp.wp18) pathlib_wpp_open(wp,wp.wp18, wp.wp18mincost); else return 18;
    if(wp.wp19) pathlib_wpp_open(wp,wp.wp19, wp.wp19mincost); else return 19;
    if(wp.wp20) pathlib_wpp_open(wp,wp.wp20, wp.wp20mincost); else return 20;
    if(wp.wp21) pathlib_wpp_open(wp,wp.wp21, wp.wp21mincost); else return 21;
    if(wp.wp22) pathlib_wpp_open(wp,wp.wp22, wp.wp22mincost); else return 22;
    if(wp.wp23) pathlib_wpp_open(wp,wp.wp23, wp.wp23mincost); else return 23;
    if(wp.wp24) pathlib_wpp_open(wp,wp.wp24, wp.wp24mincost); else return 24;
    if(wp.wp25) pathlib_wpp_open(wp,wp.wp25, wp.wp25mincost); else return 25;
    if(wp.wp26) pathlib_wpp_open(wp,wp.wp26, wp.wp26mincost); else return 26;
    if(wp.wp27) pathlib_wpp_open(wp,wp.wp27, wp.wp27mincost); else return 27;
    if(wp.wp28) pathlib_wpp_open(wp,wp.wp28, wp.wp28mincost); else return 28;
    if(wp.wp29) pathlib_wpp_open(wp,wp.wp29, wp.wp29mincost); else return 29;
    if(wp.wp30) pathlib_wpp_open(wp,wp.wp30, wp.wp30mincost); else return 30;
    if(wp.wp31) pathlib_wpp_open(wp,wp.wp31, wp.wp31mincost); else return 31;

    return 32;
}

entity pathlib_wpp_bestopen()
{
    if(best_open_node)
        return best_open_node;

    entity best = NULL;

    FOREACH_ENTITY_ENT(pathlib_list, openlist,
    {
        if(!best || it.pathlib_node_f < best.pathlib_node_f)
            best = it;
    });

    return best;

}

entity pathlib_waypointpath(entity wp_from, entity wp_to, float callback)
{
    float ptime;

    ptime 					= gettime(GETTIME_REALTIME);
    pathlib_starttime 		= ptime;
	pathlib_movecost 		= 300;
	pathlib_movecost_diag  	= vlen('1 1 0' * pathlib_movecost);

	if (!pathlib_wpp_waypointcallback)
		callback = false;

	if (callback)
		pathlib_wpp_open = pathlib_wpp_opencb;
	else
		pathlib_wpp_open = pathlib_wpp_openncb;

	pathlib_heuristic = pathlib_h_none; // We run Dijkstra, A* does not make sense with variable distanced nodes.

    if (!openlist)
        openlist       = spawn();

    if (!closedlist)
        closedlist     = spawn();

    pathlib_closed_cnt       = 0;
    pathlib_open_cnt         = 0;
    pathlib_searched_cnt     = 0;
    pathlib_foundgoal      = false;

    LOG_TRACE("pathlib_waypointpath init");

    // Initialize waypoint grid
    IL_EACH(g_waypoints, true,
    {
        it.pathlib_list = NULL;
        it.pathlib_node_g = 0;
        it.pathlib_node_f = 0;
        it.pathlib_node_h = 0;

        //setmodel(it, "models/runematch/rune.mdl");
        //it.effects = EF_LOWPRECISION;
        //it.colormod = '0 0 0';
        //it.scale = 1;
    });

    goal_node  = wp_to;
    start_node = wp_from;

    start_node.pathlib_list = closedlist;
    LOG_TRACE("Expanding ",ftos(pathlib_wpp_expand(start_node))," links");
    if(pathlib_open_cnt <= 0)
    {
        LOG_TRACE("pathlib_waypointpath: Start waypoint not linked! aborting.");
        return NULL;
    }

    return NULL;
}

entity pathlib_waypointpath_step()
{
    entity n;

    n = pathlib_wpp_bestopen();
    if(!n)
    {
        LOG_TRACE("Cannot find best open node, abort.");
        return NULL;
    }
    pathlib_wpp_close(n);
	LOG_TRACE("Expanding ",ftos(pathlib_wpp_expand(n))," links");

    if(pathlib_foundgoal)
    {
        entity start, end, open, ln;

        LOG_TRACE("Target found. Rebuilding and filtering path...");

		buildpath_nodefilter = buildpath_nodefilter_none;
		start = path_build(NULL, start_node.origin, NULL, NULL);
		end   = path_build(NULL, goal_node.origin, NULL, start);
		ln    = end;

		for(open = goal_node; open.path_prev != start_node; open = open.path_prev)
		{
			n    = path_build(ln,open.origin,open.path_prev,start);
			ln.path_prev = n;
			ln = n;
		}
		start.path_next = n;
		n.path_prev = start;

        return start;
    }

    return NULL;
}
void plas_think(entity this)
{
    pathlib_waypointpath_step();
    if(pathlib_foundgoal)
        return;
    this.nextthink = time + 0.1;
}

void pathlib_waypointpath_autostep()
{
    entity n;
    n = spawn();
    setthink(n, plas_think);
    n.nextthink = time + 0.1;
}
