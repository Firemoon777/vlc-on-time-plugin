/*****************************************************************************
 * tip.c: Translate it please VLC module
 *****************************************************************************
 * Copyright (C) 2019 Vladimir Turov
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#define DOMAIN  "vlc-myplugin"
#define _(str)  dgettext(DOMAIN, str)
#define N_(str) (str)
 
#include <stdlib.h>
/* VLC core API headers */
#include <vlc_common.h>
#include <vlc_plugin.h>
#include <vlc_interface.h>
 
/* Forward declarations */
static int Open(vlc_object_t *);
static void Close(vlc_object_t *);
 
/* Module descriptor */
vlc_module_begin()
    set_shortname(N_("On time"))
    set_description(N_("Runs video in exact time"))
    set_capability("interface", 0)
    set_callbacks(Open, Close)
    set_category(CAT_INTERFACE)
    set_subcategory( SUBCAT_INTERFACE_CONTROL )
    add_string("hello-who", "world", "Target", "Whom to say hello to.", false)
vlc_module_end ()
 
/* Internal state for an instance of the module */
struct intf_sys_t
{
    char *who;
};
 
/**
 * Starts our example interface.
 */
static int Open(vlc_object_t *obj)
{
    intf_thread_t *intf = (intf_thread_t *)obj;
 
    /* Allocate internal state */
    intf_sys_t *sys = malloc(sizeof (*sys));
    if (unlikely(sys == NULL))
        return VLC_ENOMEM;
    intf->p_sys = sys;
 
    /* Read settings */
    char *who = var_InheritString(intf, "hello-who");
    if (who == NULL)
    {
        msg_Err(intf, "Nobody to say hello to!");
        goto error;
    }
    sys->who = who;
 
    msg_Info(intf, "Hello %s!", who);
    return VLC_SUCCESS;
 
error:
    free(sys);
    return VLC_EGENERIC;    
}
 
/**
 * Stops the interface. 
 */
static void Close(vlc_object_t *obj)
{
    intf_thread_t *intf = (intf_thread_t *)obj;
    intf_sys_t *sys = intf->p_sys;
 
    msg_Info(intf, "Good bye %s!", sys->who);
 
    /* Free internal state */
    free(sys->who);
    free(sys);
}
