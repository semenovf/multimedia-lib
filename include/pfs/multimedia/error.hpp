////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021 Vladislav Trifochkin
//
// This file is part of `multimedia-lib`.
//
// Changelog:
//      2021.08.05 Initial version.
////////////////////////////////////////////////////////////////////////////////
#pragma once
#include <system_error>

namespace multimedia {

////////////////////////////////////////////////////////////////////////////////
// Error codes, category, exception class
////////////////////////////////////////////////////////////////////////////////
using error_code = std::error_code;

enum class errc
{
      success = 0
};

class error_category : public std::error_category
{
public:
    virtual char const * name () const noexcept override
    {
        return "multimedia_category";
    }

    virtual std::string message (int ev) const override
    {
        switch (ev) {
            case static_cast<int>(errc::success):
                return std::string{"no error"};

            default: return std::string{"unknown net error"};
        }
    }
};

inline std::error_category const & get_error_category ()
{
    static error_category instance;
    return instance;
}

inline std::error_code make_error_code (errc e)
{
    return std::error_code(static_cast<int>(e), get_error_category());
}

inline std::system_error make_exception (errc e)
{
    return std::system_error(make_error_code(e));
}

} // namespace multimedia

