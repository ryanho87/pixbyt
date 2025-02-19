load("render.star", "render")
load("pixlib/const.star", "const")
load("./client.star", "client")

def main(config):
    BASE_URL = config.get("base_url")
    TOKEN = config.get("token")
    resp = client.get_response(BASE_URL, TOKEN)

    # Ensure usage is an integer
    usage = int(resp["usage"]) 

    # Ensure production is an integer
    production = int(resp["production"]) if int(resp["production"]) > 0 else 0
    
    net = production - usage

    # Determine color for net value
    net_color = "#FF0000" if net < 0 else "#00FF00"

    on_rooms = []
    for name, value in resp.items():
        if name in ["usage", "production"]:
            continue
        if value == "on":
            on_rooms.append(str(name))
    on_rooms_string = ", ".join(on_rooms)

    return render.Root(
        child=render.Column(
            expanded=True,
            main_align="space_around",
            cross_align="start",  # Align text to the left
            children=[
                render.Text(content="Usage: %sw" % usage, font="CG-pixel-3x5-mono", color="#68B8ED", offset=0),
                render.Text(content="Solar: %sw" % production, font="CG-pixel-3x5-mono", color="#F0CD42", offset=0),
                render.Text(content="Net: %sw" % net, font="CG-pixel-3x5-mono", color=net_color, offset=0),
                render.Marquee(
                    width=64,
                    child=render.Text(content="Lights are on in %s" % on_rooms_string, font="CG-pixel-3x5-mono", offset=0),
                    offset_start=0,
                    offset_end=0,
                )
            ]
        )
    )
