load("render.star", "render")
load("pixlib/const.star", "const")
load("./client.star", "client")

def main(config):
    BASE_URL = config.get("base_url")
    TOKEN = config.get("token")
    resp = client.get_response(BASE_URL, TOKEN)
    usage = int(resp["usage"])  # Ensure usage is an integer

    # Ensure production is an integer
    production = int(resp["production"]) if int(resp["production"]) > 0 else 0
    
    net = production - usage

    # Determine color for net value
    net_color = "#FF0000" if net < 0 else "#00FF00"

    return render.Root(
        child=render.Column(
            expanded=True,
            main_align="space_around",
            cross_align="start",  # Align text to the left
            children=[
                render.Text(content="Usage: %sw" % usage, height=8, color="#68B8ED", offset=0),
                render.Text(content="Solar: %sw" % production, height=8, color="#F0CD42", offset=0),
                render.Text(content="Net: %sw" % net, height=8, color=net_color, offset=0)
            ]
        )
    )
