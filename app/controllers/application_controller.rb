class ApplicationController < ActionController::Base
  before_action :set_content, :set_locale

  def set_content
    @title = 'Destiny Weapons Comparison'
  end

  def set_locale
    I18n.locale = params[:lang] || I18n.default_locale
  end

  def random_d2_emblem
    emblem = [
      { # Hunter
        background: 'https://www.bungie.net/common/destiny2_content/icons/cbf554f4f41b8263a1df1aa3a29328c3.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/02f78fdc8b3c312cf6cd1e04d5beaca4.png'
      },
      { # Warlock
        background: 'https://www.bungie.net/common/destiny2_content/icons/bab07b4c0ab9fb07a3e7d622420fc929.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/9647e9aca3cc0df6fbc4fabce9e3ba75.png'
      },
      { # Titan
        background: 'https://www.bungie.net/common/destiny2_content/icons/4c3341f3c0d94e3b01b3d48cd1422924.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/5d59fcffd7d145590719fa8dc999f0c1.png'
      },
      { # Fight Forever
        background: 'https://www.bungie.net/common/destiny2_content/icons/d9c582647e974a076ce553015973d7b3.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/977641f1d7eb4c576447ccd752548dcd.png'
      },
      { # Glory to the Emperor
        background: 'https://www.bungie.net/common/destiny2_content/icons/ab51e30a2ccc7de3bc76b7a3469cb8d9.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/e14ff84b06ef0465279e95e7f2be26db.png'
      },
      { # Dead Orbit
        background: 'https://www.bungie.net/common/destiny2_content/icons/3d3729ab2ad741272af89124cf16af09.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/d5457aaab73cc758e2bdef5e4a19fa7e.png'
      },
      { # New Monarchy
        background: 'https://www.bungie.net/common/destiny2_content/icons/d85b3c9c5bb40a73f16fe631adc5593f.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/46e2bec655f1a600ebbb23114a835e7b.png'
      },
      { # FWC
        background: 'https://www.bungie.net/common/destiny2_content/icons/b5c129c8cd7732316cbd3096857c35a9.jpg',
        emblem: 'https://www.bungie.net/common/destiny2_content/icons/21946152af4387319a14be571266f0d7.png'
      }
    ]

    max_length = emblem.length - 1
    @selected_emblem = emblem[rand(0..max_length)]
  end
end
