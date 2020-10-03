select

    hash(tv_map.login_name, tv_map.billing_id) as `user`,

    tv_map.asset_id as `asset_id`,

    tv_map.watch_sec as `watch_sec`,

    collect_set(dpi.app_id) as `apps`

from

    (select

        tv.subscriber,

        tv.asset_id,

        tv.watch_sec,

        mapp.login_name,

        mapp.billing_id

    from

        (select

            split(subscriber_id, ':')[1] as subscriber,

            asset_id,

            watch_sec

        from tv_devices_log.device_content

        where

            year = 2020 and

            month = 10 and

            day = '2020-10-01' and

            asset_id is not null) as tv

    inner join

        (select

            login_name,

            billing_id,

            agreement_number

        from mapping.client_agree_login

        where

            agreement_test_flag = 0) as mapp

    on tv.subscriber = mapp.agreement_number) as tv_map

inner join

    (select

        city_id,

        login_name,

        app_id

    from dpi_profiles.eql_apps

    where

        for_day = '2020-10-01') as dpi

on tv_map.login_name = dpi.login_name and tv_map.billing_id = dpi.city_id

group by

    hash(tv_map.login_name, tv_map.billing_id),

    tv_map.asset_id,

 tv_map.watch_sec;