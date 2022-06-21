# https://discourse.julialang.org/t/allocation-due-to-noinline-for-unsafe-read-and-unsafe-write-in-io-jl/69421
@inline function _unsafe_write(io::IO, ref::Ref{T}, nb::Integer) where T
    GC.@preserve ref unsafe_write(io, Base.unsafe_convert(Ref{T}, ref)::Ptr, nb)
end

@inline function vbyte_decode(io, ::Type{T}) where {T<:Union{UInt32,Int32}}
    b = T(read(io, UInt8))
    b < 0x80 && return b

    x = b & 0x7F
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 7))

    x |= (b & 0x7F) << 7
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 14))

    x |= (b & 0x7F) << 14
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 21))

    x |= (b & 0x7F) << 21
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 28))

    x |= (b & 0x7F) << 28
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 7))

    return zero(T)
end

@inline function vbyte_decode(io, ::Type{T}) where {T<:Union{UInt64,Int64}}
    b = T(read(io, UInt8))
    b < 0x80 && return b

    x = b & 0x7F
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 7))

    x |= (b & 0x7F) << 7
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 14))

    x |= (b & 0x7F) << 14
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 21))

    x |= (b & 0x7F) << 21
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 28))

    x |= (b & 0x7F) << 28
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 35))

    x |= (b & 0x7F) << 35
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 42))

    x |= (b & 0x7F) << 42
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 49))

    x |= (b & 0x7F) << 49
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 56))

    x |= (b & 0x7F) << 56
    b = T(read(io, UInt8))
    b < 0x80 && return (x | (b << 63))

    return zero(T)
end

@inline function vbyte_encode(io::IO, x::UInt32)
    if (x < (one(UInt32) << 7))
        write(io, UInt8(x & 0x7F))
    elseif (x < (one(UInt32) << 14))
        _unsafe_write(io,
            Ref((
                UInt8(((x >> 0) & 0x7F) | (1 << 7)),
                UInt8(((x >> 7))),
            )),
            2,
        )
    elseif (x < (one(UInt32) << 21))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14))),
            )),
            3,
        )
    elseif (x < (one(UInt32) << 28))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21))),
            )),
            4,
        )
    else
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28))),
            )),
            5,
        )
    end
    return nothing;
end

@inline function vbyte_encode(io::IO, x::UInt64)
    if (x < (one(UInt64) << 7))
        write(io, UInt8(x & 0x7F))
    elseif (x < (one(UInt64) << 14))
        _unsafe_write(io,
            Ref((
                UInt8(((x >> 0) & 0x7F) | (1 << 7)),
                UInt8(((x >> 7))),
            )),
            2,
        )
    elseif (x < (one(UInt64) << 21))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14))),
            )),
            3,
        )
    elseif (x < (one(UInt64) << 28))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21))),
            )),
            4,
        )
    elseif (x < (one(UInt64) << 35))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28))),
            )),
            5,
        )
    elseif (x < (one(UInt64) << 42))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28) & 0x7F) | (1 << 7)),
                UInt8(((x >> 35))),
            )),
            6,
        )
    elseif (x < (one(UInt64) << 49))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28) & 0x7F) | (1 << 7)),
                UInt8(((x >> 35) & 0x7F) | (1 << 7)),
                UInt8(((x >> 42))),
            )),
            7,
        )
    elseif (x < (one(UInt64) << 56))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28) & 0x7F) | (1 << 7)),
                UInt8(((x >> 35) & 0x7F) | (1 << 7)),
                UInt8(((x >> 42) & 0x7F) | (1 << 7)),
                UInt8(((x >> 49))),
            )),
            8,
        )
    elseif (x < (one(UInt64) << 63))
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28) & 0x7F) | (1 << 7)),
                UInt8(((x >> 35) & 0x7F) | (1 << 7)),
                UInt8(((x >> 42) & 0x7F) | (1 << 7)),
                UInt8(((x >> 49) & 0x7F) | (1 << 7)),
                UInt8(((x >> 56))),
            )),
            9,
        )
    else
        _unsafe_write(io,
            Ref((
                UInt8(((x >>  0) & 0x7F) | (1 << 7)),
                UInt8(((x >>  7) & 0x7F) | (1 << 7)),
                UInt8(((x >> 14) & 0x7F) | (1 << 7)),
                UInt8(((x >> 21) & 0x7F) | (1 << 7)),
                UInt8(((x >> 28) & 0x7F) | (1 << 7)),
                UInt8(((x >> 35) & 0x7F) | (1 << 7)),
                UInt8(((x >> 42) & 0x7F) | (1 << 7)),
                UInt8(((x >> 49) & 0x7F) | (1 << 7)),
                UInt8(((x >> 56) & 0x7F) | (1 << 7)),
                UInt8(((x >> 63))),
            )),
            10,
        )
    end
    return nothing;
end
