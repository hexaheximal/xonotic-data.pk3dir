#include "sortlist.qh"

ERASEABLE
entity Sort_Spawn()
{
	entity sort = new_pure(sortlist);
	sort.sort_next = NULL;
	sort.chain = sort;
	return sort;
}
/*
entity Sort_New(float(entity,entity) cmp)
{
    entity sort;
    sort = spawn();
    sort.sort_cmp = cmp;
    sort.sort_next = NULL;
    sort.chain = sort;
    return sort;
}

void Sort_Remove(entity sort)
{
    entity next;
    while(sort.sort_next)
    {
        next = sort.sort_next;
        remove(sort);
        sort = next;
    }
    remove(sort);
}

void Sort_Add(entity sort, entity ent)
{
    entity next, parent;
    parent = sort;
    next = sort.sort_next;
    while(next)
    {
        if(!sort.sort_cmp(next, ent))
            break;
        parent = next;
        next = next.sort_next;
    }
    ent.sort_next = next;
    ent.sort_prev = parent;
    parent.sort_next = ent;
    if(next)
        next.sort_prev = ent;
}

void Sort_Reset(entity sort)
{
    sort.chain = sort;
}

float Sort_HasNext(entity sort)
{
    return (sort.chain.sort_next != NULL);
}

entity Sort_Next(entity sort)
{
    entity next;
    next = sort.chain.sort_next;
    if(!next) {
        next = spawn();
        sort.chain.sort_next = next;
        next.sort_prev = sort.chain;
        next.sort_next = NULL;
    }
    sort.chain = next;
    return next;
}

void Sort_Finish(entity sort)
{
    entity next;
    next = sort.chain;
    if(!next)
        return;

    while(next.sort_next)
    {
        sort = next.sort_next;
        next.sort_next = sort.sort_next;
        remove(sort);
    }
}

entity Sort_Get(entity sort, float i)
{
    for (; sort.sort_next && i > 0; --i)
        sort = sort.sort_next;
    return sort;
}
*/

/*
void Sort_Erase(entity ent)
{
    ent.sort_prev.sort_next = ent.sort_next;
    if(ent.sort_next)
        ent.sort_next.sort_prev = ent.sort_prev;
    remove(ent);
}

void Sort_RemoveOld(entity sort)
{
    entity tmp;
    for(tmp = sort.sort_next; tmp; tmp = tmp.sort_next)
    {
        if(tmp.frame < time)
        {
            tmp = tmp.sort_prev;
            Sort_Erase(tmp.sort_next);
        }
    }
}
*/
