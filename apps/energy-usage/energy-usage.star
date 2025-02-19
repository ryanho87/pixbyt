load("render.star", "render")
load("pixlib/const.star", "const")
load("./client.star", "client")

def main(config):
    BASE_URL = config.get("base_url")
    TOKEN = config.get("token")
    resp = client.get_response(BASE_URL, TOKEN)

    # Always Render Usage, Production, and Net Energy
    usage = int(resp["usage"])
    production = int(resp["production"]) if int(resp["production"]) > 0 else 0
    net = production - usage
    net_color = "#FF0000" if net < 0 else "#00FF00"

    # Collect rooms that are on
    on_rooms = [str(name) for name, value in resp.items() if name not in ["usage", "production"] and value == "on"]

    # Choose font size based on whether marquee is present
    font_size = "CG-pixel-3x5-mono" if on_rooms else "CG-pixel-4x5-mono"

    render_children = [
        render.Text(content="Usage: %sw" % usage, font=font_size, color="#68B8ED", offset=0),
        render.Text(content="Solar: %sw" % production, font=font_size, color="#F0CD42", offset=0),
        render.Text(content="Net: %sw" % net, font=font_size, color=net_color, offset=0),
    ]

    # Add the marquee if there are rooms with lights on
    if on_rooms:
        render_children.append(
            render.Marquee(
                width=64,
                child=render.Text(content="Lights are on in %s" % ", ".join(on_rooms), font=font_size, offset=0),
                offset_start=0,
                offset_end=0,
            )
        )

    return render.Root(
        child=render.Column(
            expanded=True,
            main_align="space_around",
            cross_align="start",
            children=render_children
        )
    )
