const hyprland = await Service.import("hyprland")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")
import brightness from "./brightness.js"


// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

function Workspaces() {
    const activeId = hyprland.active.workspace.bind("id")
    const workspaces = hyprland.bind("workspaces")
        .as(ws => ws.map(({ id }) => Widget.Button({
            on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
            child: Widget.Label(`${id}`),
            class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
        })))

    return Widget.Box({
        class_name: "workspaces",
        vertical: true,
        vpack: "center",
        children: workspaces,
    })
}


function ClientTitle() {
    return Widget.Label({
        class_name: "client-title",
        label: hyprland.active.client.bind("title"),
    })
}

const time = Variable("", {
    poll: [1000, `date +'%H\n%M'`],
})
const date = Variable("", {
    poll: [1000, `date +'%m-%d'`],
})
const day = Variable("", {
    poll: [1000, `date +'%d'`],
})
const month = Variable("", {
    poll: [1000, `date +'%m'`],
})

function Clock() {
    return Widget.Label({
        class_name: "clock",
        vpack: "center",
        label: time.bind(),
    })
}
function Date() {
    return Widget.Label({
        class_name: "date",
        vpack: "center",
        label: date.bind(),
    })
}

function DateTime() {
    return Widget.Box({
        vertical: true,
        vpack: "center",
        children: [
            Widget.Label({
                class_name: "time",
                vpack: "center",
                label: time.bind(),
            }),
            Widget.Label({
                class_name: "date2",
                vpack: "center",
                label: date.bind(),
            }),

        ]
    })
}


function Media() {
    return Widget.Button({
        class_name: "media",
        on_primary_click: () => mpris.getPlayer("")?.playPause(),
        on_scroll_up: () => mpris.getPlayer("")?.next(),
        on_scroll_down: () => mpris.getPlayer("")?.previous(),
    })
}


function Volume() {
    const icons = {
        101: "overamplified",
        67: "high",
        34: "medium",
        1: "low",
        0: "muted",
    }

    function getIcon() {
        const icon = audio.speaker.is_muted ? 0 : [101, 67, 34, 1, 0].find(
            threshold => threshold <= audio.speaker.volume * 100)

        return `audio-volume-${icons[icon]}-symbolic`
    }

    const icon = Widget.Icon({
        icon: Utils.watch(getIcon(), audio.speaker, getIcon),
    })

    const slider = Widget.Slider({
        vertical: true,
        inverted: true,
        expand: true,
        draw_value: false,
        on_change: ({ value }) => audio.speaker.volume = value,
        setup: self => self.hook(audio.speaker, () => {
            self.value = audio.speaker.volume || 0
        }),
    })

    return Widget.Box({
        vertical: true,
        vpack: "start",
        class_name: "volume",
        children: [icon, slider],
    })
}

function Brightness() {
    const slider = Widget.Slider({
        vertical: true,
        inverted: true,
        expand: true,
        draw_value: false,
        class_name: "brightness",
        on_change: self => brightness.screen_value = self.value,
        value: brightness.bind('screen-value'),
    });
    return slider
}


function BatteryLabel() {
    const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
    const icon = battery.bind("percent").as(p =>
        `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

    return Widget.Box({
        class_name: "battery",
        vertical: true,
        visible: battery.bind("available"),
        children: [
            Widget.Icon({ class_name: "icon", icon }),
            Widget.LevelBar({
                vertical: true,
                inverted: true,
                heightRequest: 140,
                vpack: "center",
                value,
            }),
        ],
    })
}


function SysTray() {
    const items = systemtray.bind("items")
        .as(items => items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind("icon") }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind("tooltip_markup"),
        })))

    return Widget.Box({
        vertical: true,
        children: items,
    })
}

const Separator = Widget.Separator({
    vertical: true,
    class_name: "separator",
})

function Dnd() {
    return Widget.Button({
        child: Widget.Label('dnd'),
        onClicked: () => {
            console.log('DND button clicked'); // Add debugging
            Utils.exec(`${Utils.HOME}/.config/hypr/scripts/dnd.sh`);
        }
    })
}

// layout of the bar
function Top() {
    return Widget.Box({
        vertical: true,
        spacing: 8,
        children: [
            //ClientTitle(),
            //Volume(),
            Volume(),
            Brightness(),
        ],
    })
}

function Center() {
    return Widget.Box({
        vertical: true,
        spacing: 8,
        children: [
            //Media(),
            //Notification(),
            Workspaces(),
        ],
    })
}

function Bottom() {
    return Widget.Box({
        vertical: true,
        vpack: "end",
        spacing: 8,
        children: [
            BatteryLabel(),
            Dnd(),
            SysTray(),
            DateTime(),
        ],
    })
}

function Bar(monitor = 0) {
    return Widget.Window({
        name: `bar-${monitor}`, // name has to be unique
        class_name: "bar",
        monitor,
        anchor: ["right", "top", "bottom"],
        exclusivity: "exclusive",
        margins: [5, 5, 5, 0],
        child: Widget.CenterBox({
            vertical: true,
            start_widget: Top(),
            center_widget: Center(),
            end_widget: Bottom(),
        }),
    })
}

App.config({
    style: "./style.css",
    windows: [
        Bar(),

        // you can call it, for each monitor
        // Bar(0),
        // Bar(1)
    ],
})

export { }
